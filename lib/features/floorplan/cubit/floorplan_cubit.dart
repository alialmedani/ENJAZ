import 'package:bloc/bloc.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/data/model/desk_user_model.dart';
import 'package:enjaz/features/floorplan/data/model/floor_layout_model.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';
import 'package:enjaz/features/floorplan/data/usecase/assign_user_to_desk.dart';
import 'package:enjaz/features/floorplan/data/usecase/check_in.dart';
import 'package:enjaz/features/floorplan/data/usecase/check_out.dart';
import 'package:enjaz/features/floorplan/data/usecase/get_floor_layout.dart';
import 'package:enjaz/features/floorplan/data/usecase/get_floor_presence.dart';
import 'package:enjaz/features/floorplan/data/usecase/get_users_autocomplete.dart';
import 'package:enjaz/features/floorplan/data/usecase/heartbeat.dart';
import 'package:enjaz/features/floorplan/data/usecase/move_desk.dart';
import 'package:meta/meta.dart';

part 'floorplan_state.dart';

class FloorplanCubit extends Cubit<FloorplanState> {
  FloorplanCubit() : super(FloorplanInitial());

  final FloorplanRepository _repository = FloorplanRepository();

  FloorLayoutModel? _layout;
  FloorLayoutModel? get layout => _layout;

  /// Loads (or reloads) the floor layout for [floorId].
  Future<void> loadLayout(String floorId) async {
    emit(FloorplanLoading());
    final Result<FloorLayoutModel> result = await GetFloorLayoutUsecase(
      _repository,
    ).call(params: GetFloorLayoutParam(floorId: floorId));

    if (result.hasDataOnly) {
      _layout = result.data;
      emit(FloorplanLoaded(_layout!));
    } else {
      emit(FloorplanError(result.error ?? 'err_unexpected'));
    }
  }

  /// Persists a desk move to absolute plan pixels (x, y).
  Future<void> moveDesk({
    required String deskId,
    required int x,
    required int y,
  }) async {
    final current = _layout;
    if (current == null) return;

    emit(FloorplanDeskUpdating(current, deskId));

    final result = await MoveDeskUsecase(
      _repository,
    ).call(params: MoveDeskParam(deskId: deskId, x: x, y: y));

    if (result.hasDataOnly) {
      _replaceDesk(result.data!);
      emit(FloorplanActionSuccess(_layout!));
      emit(FloorplanLoaded(_layout!));
    } else {
      emit(FloorplanActionError(current, result.error ?? 'err_unexpected'));
      emit(FloorplanLoaded(current));
    }
  }

  /// Assigns [userId] to a desk; pass null to clear the seat.
  Future<void> assignUser({
    required String deskId,
    required String? userId,
  }) async {
    final current = _layout;
    if (current == null) return;

    emit(FloorplanDeskUpdating(current, deskId));

    final result = await AssignUserToDeskUsecase(_repository).call(
      params: AssignUserToDeskParam(deskId: deskId, userId: userId),
    );

    if (result.hasDataOnly) {
      _replaceDesk(result.data!);
      emit(FloorplanActionSuccess(_layout!));
      emit(FloorplanLoaded(_layout!));
    } else {
      emit(FloorplanActionError(current, result.error ?? 'err_unexpected'));
      emit(FloorplanLoaded(current));
    }
  }

  /// Fetches users for the assign dialog. Returns an empty list on failure.
  Future<List<DeskUserModel>> searchUsers(String term) async {
    final result = await GetUsersAutocompleteUsecase(
      _repository,
    ).call(params: GetUsersAutocompleteParam(term: term));
    return result.hasDataOnly ? result.data! : <DeskUserModel>[];
  }

  void _replaceDesk(DeskModel updated) {
    final current = _layout;
    if (current == null) return;
    final desks = current.desks
        .map((d) => d.id == updated.id ? updated : d)
        .toList();
    _layout = current.copyWith(desks: desks);
  }

  // -------------------------- Presence (Slice 2) -------------------------

  PresenceModel? _myPresence;
  PresenceModel? get myPresence => _myPresence;

  /// Checks the current user in to [floorId] (and optionally [deskId]).
  /// Reloads the layout afterwards so the presence dots reflect the change.
  Future<void> checkIn({required String floorId, String? deskId}) async {
    final result = await CheckInUsecase(
      _repository,
    ).call(params: CheckInParam(floorId: floorId, deskId: deskId));

    if (result.hasDataOnly) {
      _myPresence = result.data;
      emit(FloorplanPresenceSuccess('floorplan_checked_in'));
      await loadLayout(floorId);
    } else {
      final current = _layout;
      final message = result.error ?? 'err_unexpected';
      if (current != null) {
        emit(FloorplanActionError(current, message));
        emit(FloorplanLoaded(current));
      } else {
        emit(FloorplanError(message));
      }
    }
  }

  /// Fire-and-forget heartbeat (called by the screen's periodic timer).
  Future<void> heartbeat() async {
    final result = await HeartbeatUsecase(
      _repository,
    ).call(params: HeartbeatParam());
    if (result.hasDataOnly) _myPresence = result.data;
  }

  /// Best-effort check-out (called on screen dispose).
  Future<void> checkOut() async {
    final result = await CheckOutUsecase(
      _repository,
    ).call(params: CheckOutParam());
    if (result.hasDataOnly) _myPresence = result.data;
  }

  /// Fetches the live presence list for [floorId]. Empty on failure.
  Future<List<PresenceModel>> getFloorPresence(String floorId) async {
    final result = await GetFloorPresenceUsecase(
      _repository,
    ).call(params: GetFloorPresenceParam(floorId: floorId));
    return result.hasDataOnly ? result.data! : <PresenceModel>[];
  }

  // ------------------------ Real-time (FCM) patches ----------------------

  /// Patches a single desk's position from a `DeskMoved` event without a
  /// full reload. No-op when the desk is not in the current layout.
  void applyDeskMoved({required String deskId, int? x, int? y}) {
    final current = _layout;
    if (current == null) return;
    final idx = current.desks.indexWhere((d) => d.id == deskId);
    if (idx < 0) return;
    final desk = current.desks[idx];
    _replaceDesk(desk.copyWith(x: x ?? desk.x, y: y ?? desk.y));
    emit(FloorplanLoaded(_layout!));
  }

  /// Patches a single desk's assignment from a `DeskAssigned` event.
  /// A null/empty [assignedUserId] clears the seat.
  void applyDeskAssigned({
    required String deskId,
    String? assignedUserId,
    String? assignedUserName,
    int? assignedUserStatus,
  }) {
    final current = _layout;
    if (current == null) return;
    final idx = current.desks.indexWhere((d) => d.id == deskId);
    if (idx < 0) return;
    final desk = current.desks[idx];
    final clear = assignedUserId == null || assignedUserId.isEmpty;
    _replaceDesk(
      desk.copyWith(
        clearUser: clear,
        assignedUserId: assignedUserId,
        assignedUserName: assignedUserName,
        assignedUserStatus: assignedUserStatus,
      ),
    );
    emit(FloorplanLoaded(_layout!));
  }

  /// Patches the presence status of whichever desk the given user occupies
  /// from a `PresenceChanged` event. Falls back to the [deskId] when given.
  void applyPresenceChanged({
    String? userId,
    String? deskId,
    int? status,
  }) {
    final current = _layout;
    if (current == null) return;
    final idx = current.desks.indexWhere(
      (d) =>
          (deskId != null && d.id == deskId) ||
          (userId != null && d.assignedUserId == userId),
    );
    if (idx < 0) return;
    final desk = current.desks[idx];
    _replaceDesk(desk.copyWith(assignedUserStatus: status));
    emit(FloorplanLoaded(_layout!));
  }
}

import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/data/model/desk_user_model.dart';
import 'package:enjaz/features/floorplan/data/model/directory_item_model.dart';
import 'package:enjaz/features/floorplan/data/model/floor_layout_model.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/data/usecase/assign_user_to_desk.dart';
import 'package:enjaz/features/floorplan/data/usecase/check_in.dart';
import 'package:enjaz/features/floorplan/data/usecase/department_autocomplete.dart';
import 'package:enjaz/features/floorplan/data/usecase/get_floor_layout.dart';
import 'package:enjaz/features/floorplan/data/usecase/get_floor_presence.dart';
import 'package:enjaz/features/floorplan/data/usecase/get_users_autocomplete.dart';
import 'package:enjaz/features/floorplan/data/usecase/move_desk.dart';
import 'package:enjaz/features/floorplan/data/usecase/search_directory.dart';

class FloorplanRepository extends CoreRepository {
  Future<Result<FloorLayoutModel>> getFloorLayout({
    required GetFloorLayoutParam params,
  }) async {
    final result = await RemoteDataSource.request<FloorLayoutModel>(
      withAuthentication: true,
      url: '$getFloorLayoutUrl/${params.floorId}',
      method: HttpMethod.GET,
      converter: (json) => FloorLayoutModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<DeskModel>> moveDesk({required MoveDeskParam params}) async {
    final result = await RemoteDataSource.request<DeskModel>(
      withAuthentication: true,
      url: moveDeskUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => DeskModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<DeskModel>> assignUserToDesk({
    required AssignUserToDeskParam params,
  }) async {
    final result = await RemoteDataSource.request<DeskModel>(
      withAuthentication: true,
      url: assignUserToDeskUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => DeskModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<List<DeskUserModel>>> getUsersAutocomplete({
    required GetUsersAutocompleteParam params,
  }) async {
    final result = await RemoteDataSource.request<List<DeskUserModel>>(
      withAuthentication: true,
      url: getUserAutocompleteUrl,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter2: (json) => List<DeskUserModel>.from(
        (json as List).map((x) => DeskUserModel.fromJson(x)),
      ),
    );
    return call(result: result);
  }

  // ----------------------- Presence (Slice 2) ---------------------------

  Future<Result<PresenceModel>> checkIn({required CheckInParam params}) async {
    final result = await RemoteDataSource.request<PresenceModel>(
      withAuthentication: true,
      url: presenceCheckInUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => PresenceModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<PresenceModel>> heartbeat() async {
    final result = await RemoteDataSource.request<PresenceModel>(
      withAuthentication: true,
      url: presenceHeartbeatUrl,
      method: HttpMethod.POST,
      data: const {},
      converter: (json) => PresenceModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<PresenceModel>> checkOut() async {
    final result = await RemoteDataSource.request<PresenceModel>(
      withAuthentication: true,
      url: presenceCheckOutUrl,
      method: HttpMethod.POST,
      data: const {},
      converter: (json) => PresenceModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<List<PresenceModel>>> getFloorPresence({
    required GetFloorPresenceParam params,
  }) async {
    final result = await RemoteDataSource.request<List<PresenceModel>>(
      withAuthentication: true,
      url: '$floorPresenceUrl/${params.floorId}',
      method: HttpMethod.GET,
      converter2: (json) => List<PresenceModel>.from(
        (json as List).map((x) => PresenceModel.fromJson(x)),
      ),
    );
    return call(result: result);
  }

  // ----------------- Directory & Department (Slice 2) -------------------

  Future<Result<DirectorySearchResult>> searchDirectory({
    required SearchDirectoryParam params,
  }) async {
    final result = await RemoteDataSource.request<DirectorySearchResult>(
      withAuthentication: true,
      url: directorySearchUrl,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter: (json) => DirectorySearchResult.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<List<DepartmentItemModel>>> departmentAutocomplete({
    required DepartmentAutocompleteParam params,
  }) async {
    final result = await RemoteDataSource.request<List<DepartmentItemModel>>(
      withAuthentication: true,
      url: departmentAutocompleteUrl,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter2: (json) => List<DepartmentItemModel>.from(
        (json as List).map((x) => DepartmentItemModel.fromJson(x)),
      ),
    );
    return call(result: result);
  }
}

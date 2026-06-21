part of 'floorplan_cubit.dart';

@immutable
sealed class FloorplanState {}

final class FloorplanInitial extends FloorplanState {}

final class FloorplanLoading extends FloorplanState {}

final class FloorplanLoaded extends FloorplanState {
  final FloorLayoutModel layout;
  FloorplanLoaded(this.layout);
}

final class FloorplanError extends FloorplanState {
  final String message;
  FloorplanError(this.message);
}

/// Emitted while a per-desk mutation (move / assign) is in flight, so the
/// screen can keep showing the current layout but reflect a busy desk.
final class FloorplanDeskUpdating extends FloorplanState {
  final FloorLayoutModel layout;
  final String deskId;
  FloorplanDeskUpdating(this.layout, this.deskId);
}

final class FloorplanActionError extends FloorplanState {
  final FloorLayoutModel layout;
  final String message;
  FloorplanActionError(this.layout, this.message);
}

/// Emitted after a successful move/assign so the UI can show a confirmation.
final class FloorplanActionSuccess extends FloorplanState {
  final FloorLayoutModel layout;
  FloorplanActionSuccess(this.layout);
}

/// Emitted after a successful presence action (check-in). [messageKey] is an
/// easy_localization key the screen can show in a snackbar.
final class FloorplanPresenceSuccess extends FloorplanState {
  final String messageKey;
  FloorplanPresenceSuccess(this.messageKey);
}

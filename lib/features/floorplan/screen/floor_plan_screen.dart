import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/features/floorplan/cubit/floorplan_cubit.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/data/model/floor_layout_model.dart';
import 'package:enjaz/features/floorplan/widget/assign_user_dialog.dart';
import 'package:enjaz/features/floorplan/widget/desk_marker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

/// Floor-plan screen: renders the plan image in a zoom/pan canvas and overlays
/// desks at scaled (x, y) coordinates. Long-press + drag repositions a desk
/// (move_desk); tap opens the assign dialog (assign_user_to_desk).
///
/// Slice 2 adds: presence dots per occupied desk, a "Check in here" action, a
/// periodic heartbeat timer, and a screen-scoped FCM listener on the
/// `floor_{floorId}` topic that patches/reloads the layout on real-time events.
class FloorPlanScreen extends StatelessWidget {
  final String floorId;

  /// Optional desk id to focus/highlight (e.g. when opened from directory).
  final String? highlightDeskId;

  const FloorPlanScreen({
    super.key,
    required this.floorId,
    this.highlightDeskId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FloorplanCubit()..loadLayout(floorId),
      child: _FloorPlanView(
        floorId: floorId,
        highlightDeskId: highlightDeskId,
      ),
    );
  }
}

class _FloorPlanView extends StatefulWidget {
  final String floorId;
  final String? highlightDeskId;
  const _FloorPlanView({required this.floorId, this.highlightDeskId});

  @override
  State<_FloorPlanView> createState() => _FloorPlanViewState();
}

class _FloorPlanViewState extends State<_FloorPlanView> {
  final PhotoViewController _photoController = PhotoViewController();

  // Default plan dimensions used when the backend does not supply them.
  static const double _fallbackPlanWidth = 1000;
  static const double _fallbackPlanHeight = 1000;

  // Id of the desk currently being dragged (drag suppresses pan in PhotoView).
  String? _draggingDeskId;

  // --- Slice 2 real-time / presence plumbing ---
  /// Heartbeat cadence while the screen is open.
  static const Duration _heartbeatInterval = Duration(seconds: 60);
  Timer? _heartbeatTimer;

  /// Screen-scoped FCM foreground subscription (separate from the app's global
  /// notification handling); cancelled on dispose so it never leaks.
  StreamSubscription<RemoteMessage>? _fcmSub;

  String get _topic => 'floor_${widget.floorId}';

  @override
  void initState() {
    super.initState();
    _subscribeRealtime();
  }

  /// Subscribes to the floor topic and attaches a scoped foreground listener.
  Future<void> _subscribeRealtime() async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(_topic);
    } catch (e) {
      if (kDebugMode) debugPrint('subscribeToTopic($_topic) failed: $e');
    }
    // Additional, scoped onMessage listener: only reacts to our floor events
    // and does NOT replace the app's global FirebaseNotification handler.
    _fcmSub = FirebaseMessaging.onMessage.listen(_onFloorMessage);
  }

  /// Handles a foreground data message carrying a known floor `event`.
  void _onFloorMessage(RemoteMessage message) {
    if (!mounted) return;
    final data = message.data;
    final String? event = data['event']?.toString();
    if (event == null) return;

    // Ignore events meant for other floors when a floorId is provided.
    final String? msgFloorId = data['floorId']?.toString();
    if (msgFloorId != null &&
        msgFloorId.isNotEmpty &&
        msgFloorId != widget.floorId) {
      return;
    }

    final cubit = context.read<FloorplanCubit>();
    switch (event) {
      case 'DeskMoved':
        final deskId = data['deskId']?.toString();
        if (deskId == null || deskId.isEmpty) return;
        cubit.applyDeskMoved(
          deskId: deskId,
          x: int.tryParse(data['x']?.toString() ?? ''),
          y: int.tryParse(data['y']?.toString() ?? ''),
        );
        break;
      case 'DeskAssigned':
        final deskId = data['deskId']?.toString();
        if (deskId == null || deskId.isEmpty) return;
        cubit.applyDeskAssigned(
          deskId: deskId,
          assignedUserId: data['assignedUserId']?.toString(),
          assignedUserName: data['assignedUserName']?.toString(),
          assignedUserStatus:
              int.tryParse(data['assignedUserStatus']?.toString() ?? ''),
        );
        break;
      case 'PresenceChanged':
        cubit.applyPresenceChanged(
          userId: data['userId']?.toString(),
          deskId: data['deskId']?.toString(),
          status: int.tryParse(data['status']?.toString() ?? ''),
        );
        break;
      default:
        // Unknown event: fall back to a full reload to stay consistent.
        cubit.loadLayout(widget.floorId);
    }
  }

  void _startHeartbeat(FloorplanCubit cubit) {
    // Idempotent: schedule only once for the lifetime of the screen.
    if (_heartbeatTimer != null) return;
    _heartbeatTimer = Timer.periodic(
      _heartbeatInterval,
      (_) => cubit.heartbeat(),
    );
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    _fcmSub?.cancel();
    // Best-effort topic unsubscribe + check-out; fire-and-forget.
    FirebaseMessaging.instance.unsubscribeFromTopic(_topic).catchError((_) {});
    _photoController.dispose();
    super.dispose();
  }

  String _planImageUrl(String documentId) =>
      '$documentDownloadUrl/$documentId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FloorplanCubit, FloorplanState>(
          builder: (context, state) {
            final layout = context.read<FloorplanCubit>().layout;
            return Text(layout?.floorName ?? 'floorplan_title'.tr());
          },
        ),
        actions: [
          IconButton(
            tooltip: 'floorplan_reload'.tr(),
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<FloorplanCubit>().loadLayout(widget.floorId),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<FloorplanCubit, FloorplanState>(
        builder: (context, state) {
          final ready = context.read<FloorplanCubit>().layout != null;
          if (!ready) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.login),
            label: Text('floorplan_check_in_here'.tr()),
            onPressed: () =>
                context.read<FloorplanCubit>().checkIn(floorId: widget.floorId),
          );
        },
      ),
      body: BlocConsumer<FloorplanCubit, FloorplanState>(
        listener: (context, state) {
          if (state is FloorplanLoaded) {
            // Start the heartbeat once we have a layout (idempotent: only the
            // first call schedules; subsequent ones reset the timer).
            _startHeartbeat(context.read<FloorplanCubit>());
          } else if (state is FloorplanActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is FloorplanPresenceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.messageKey.tr()),
                backgroundColor: AppColors.green,
              ),
            );
          } else if (state is FloorplanActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('floorplan_saved'.tr()),
                backgroundColor: AppColors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FloorplanLoading || state is FloorplanInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FloorplanError) {
            return _ErrorBody(
              message: state.message,
              onRetry: () =>
                  context.read<FloorplanCubit>().loadLayout(widget.floorId),
            );
          }

          final layout = context.read<FloorplanCubit>().layout;
          if (layout == null) {
            return _ErrorBody(
              message: 'err_unexpected'.tr(),
              onRetry: () =>
                  context.read<FloorplanCubit>().loadLayout(widget.floorId),
            );
          }

          final busyDeskId =
              state is FloorplanDeskUpdating ? state.deskId : null;

          return LayoutBuilder(
            builder: (context, constraints) {
              final planW =
                  (layout.planWidth ?? _fallbackPlanWidth.toInt()).toDouble();
              final planH =
                  (layout.planHeight ?? _fallbackPlanHeight.toInt()).toDouble();

              // Fit the plan canvas inside the viewport while preserving aspect
              // ratio. Marker (x, y) are scaled from plan pixels to this canvas.
              final double scale = _fitScale(
                planW,
                planH,
                constraints.maxWidth,
                constraints.maxHeight,
              );
              final double canvasW = planW * scale;
              final double canvasH = planH * scale;

              return PhotoView.customChild(
                controller: _photoController,
                backgroundDecoration:
                    const BoxDecoration(color: AppColors.whiteF3),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                initialScale: PhotoViewComputedScale.contained,
                childSize: Size(canvasW, canvasH),
                child: _PlanCanvas(
                  width: canvasW,
                  height: canvasH,
                  scale: scale,
                  layout: layout,
                  busyDeskId: busyDeskId,
                  highlightDeskId: widget.highlightDeskId,
                  imageUrl: layout.hasPlanImage
                      ? _planImageUrl(layout.floorPlanImageId!)
                      : null,
                  photoController: _photoController,
                  onDragStart: (id) => setState(() => _draggingDeskId = id),
                  onDragEnd: () => setState(() => _draggingDeskId = null),
                  draggingDeskId: _draggingDeskId,
                  onMove: (desk, planX, planY) {
                    context.read<FloorplanCubit>().moveDesk(
                          deskId: desk.id!,
                          x: planX,
                          y: planY,
                        );
                  },
                  onTapDesk: (desk) => _openAssignDialog(context, desk),
                ),
              );
            },
          );
        },
      ),
    );
  }

  double _fitScale(double planW, double planH, double maxW, double maxH) {
    if (planW <= 0 || planH <= 0) return 1;
    final sx = maxW / planW;
    final sy = maxH / planH;
    final s = sx < sy ? sx : sy;
    return s.isFinite && s > 0 ? s : 1;
  }

  Future<void> _openAssignDialog(BuildContext context, DeskModel desk) async {
    final cubit = context.read<FloorplanCubit>();
    final result = await showAssignUserDialog(
      context: context,
      cubit: cubit,
      desk: desk,
    );
    if (result == null) return;
    if (result.clear) {
      await cubit.assignUser(deskId: desk.id!, userId: null);
    } else if (result.user?.id != null) {
      await cubit.assignUser(deskId: desk.id!, userId: result.user!.id);
    }
  }
}

/// The fixed-size canvas (image + desk markers) hosted inside [PhotoView].
class _PlanCanvas extends StatelessWidget {
  final double width;
  final double height;
  final double scale;
  final FloorLayoutModel layout;
  final String? busyDeskId;
  final String? highlightDeskId;
  final String? imageUrl;
  final PhotoViewController photoController;
  final String? draggingDeskId;
  final ValueChanged<String> onDragStart;
  final VoidCallback onDragEnd;
  final void Function(DeskModel desk, int planX, int planY) onMove;
  final ValueChanged<DeskModel> onTapDesk;

  const _PlanCanvas({
    required this.width,
    required this.height,
    required this.scale,
    required this.layout,
    required this.busyDeskId,
    required this.highlightDeskId,
    required this.imageUrl,
    required this.photoController,
    required this.draggingDeskId,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onMove,
    required this.onTapDesk,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Floor plan image (or a placeholder grid when none is provided).
          Positioned.fill(
            child: imageUrl == null
                ? const ColoredBox(color: AppColors.whiteF1)
                : CachedImage(imageUrl: imageUrl, fit: BoxFit.fill),
          ),
          for (final desk in layout.desks)
            _DraggableDesk(
              key: ValueKey(desk.id),
              desk: desk,
              scale: scale,
              busy: desk.id == busyDeskId,
              highlighted: highlightDeskId != null && desk.id == highlightDeskId,
              photoController: photoController,
              isDragging: desk.id == draggingDeskId,
              onDragStart: () => onDragStart(desk.id ?? ''),
              onDragEnd: onDragEnd,
              onMove: (planX, planY) => onMove(desk, planX, planY),
              onTap: () => onTapDesk(desk),
            ),
        ],
      ),
    );
  }
}

class _DraggableDesk extends StatefulWidget {
  final DeskModel desk;
  final double scale;
  final bool busy;
  final bool highlighted;
  final bool isDragging;
  final PhotoViewController photoController;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final void Function(int planX, int planY) onMove;
  final VoidCallback onTap;

  const _DraggableDesk({
    super.key,
    required this.desk,
    required this.scale,
    required this.busy,
    required this.highlighted,
    required this.isDragging,
    required this.photoController,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onMove,
    required this.onTap,
  });

  @override
  State<_DraggableDesk> createState() => _DraggableDeskState();
}

class _DraggableDeskState extends State<_DraggableDesk> {
  // Live canvas-space position while dragging (null when not dragging).
  Offset? _dragPos;
  // Canvas-space anchor captured at long-press start.
  Offset _dragAnchor = Offset.zero;

  double get _baseLeft => (widget.desk.x ?? 0) * widget.scale;
  double get _baseTop => (widget.desk.y ?? 0) * widget.scale;

  @override
  Widget build(BuildContext context) {
    final left = _dragPos?.dx ?? _baseLeft;
    final top = _dragPos?.dy ?? _baseTop;

    return Positioned(
      left: left,
      top: top,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onLongPressStart: (_) {
            _dragAnchor = Offset(_baseLeft, _baseTop);
            setState(() => _dragPos = _dragAnchor);
            widget.onDragStart();
          },
          onLongPressMoveUpdate: (details) {
            // offsetFromOrigin is the cumulative global drag since press start.
            // Divide by the current PhotoView zoom so movement tracks 1:1 with
            // the finger regardless of how far the plan is zoomed in.
            final zoom = widget.photoController.scale ?? 1.0;
            setState(() {
              _dragPos = _dragAnchor + details.offsetFromOrigin / zoom;
            });
          },
          onLongPressEnd: (_) {
            final pos = _dragPos;
            widget.onDragEnd();
            if (pos != null && widget.scale > 0) {
              final planX = (pos.dx / widget.scale).round();
              final planY = (pos.dy / widget.scale).round();
              widget.onMove(planX, planY);
            }
            setState(() => _dragPos = null);
          },
          child: Opacity(
            opacity: widget.isDragging ? 0.85 : 1,
            child: Container(
              decoration: widget.highlighted
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.lightAccentColor,
                        width: 2.5,
                      ),
                    )
                  : null,
              child: DeskMarker(desk: widget.desk, busy: widget.busy),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.red),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('floorplan_reload'.tr()),
          ),
        ],
      ),
    );
  }
}

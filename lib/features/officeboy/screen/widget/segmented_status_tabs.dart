// segmented_status_tabs_ultra.dart
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

/// ========= Enum تبعك =========
enum OrderStatus {
  draft,
  submitted,
  inPreparation,
  ready,
  delivered,
  canceled;

  static OrderStatus? fromInt(int? value) {
    switch (value) {
      case 0:
        return OrderStatus.draft;
      case 1:
        return OrderStatus.submitted;
      case 2:
        return OrderStatus.inPreparation;
      case 3:
        return OrderStatus.ready;
      case 4:
        return OrderStatus.delivered;
      case 5:
        return OrderStatus.canceled;
      default:
        return null;
    }
  }

  int toInt() {
    switch (this) {
      case OrderStatus.draft:
        return 0;
      case OrderStatus.submitted:
        return 1;
      case OrderStatus.inPreparation:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.canceled:
        return 5;
    }
  }
}

String _statusKey(OrderStatus s) {
  switch (s) {
    case OrderStatus.draft:
      return 'status_draft';
    case OrderStatus.submitted:
      return 'status_submitted';
    case OrderStatus.inPreparation:
      return 'status_in_preparation';
    case OrderStatus.ready:
      return 'status_ready';
    case OrderStatus.delivered:
      return 'status_delivered';
    case OrderStatus.canceled:
      return 'status_canceled';
  }
}

/// كم تبويب بدّك؟ استعملها لبناء الcontroller عندك (خارجي)
int requiredTabsCount({
  bool showAll = true,
  bool excludeDraft = true,
  List<OrderStatus>? order,
}) {
  final o =
      order ??
      const [
        OrderStatus.submitted,
        OrderStatus.inPreparation,
        OrderStatus.ready,
        OrderStatus.delivered,
        OrderStatus.canceled,
      ];
  final list = excludeDraft
      ? o.where((e) => e != OrderStatus.draft).toList()
      : o;
  return (showAll ? 1 : 0) + list.length;
}

/// =======================
/// Ultra Advanced Segmented Tabs
/// - Indicator مرن (spring)
/// - Glow + Breathing gloss
/// - Frosted glass خلفية
/// - تمايل/Scale عند الاختيار
/// =======================
class SegmentedStatusTabsUltra extends StatefulWidget {
  final TabController controller;
  final bool showAll;
  final bool excludeDraft;
  final ValueChanged<OrderStatus?>? onChanged;
  final List<OrderStatus> order;

  const SegmentedStatusTabsUltra({
    super.key,
    required this.controller,
    this.showAll = true,
    this.excludeDraft = true,
    this.onChanged,
    List<OrderStatus>? order,
  }) : order =
           order ??
           const [
             OrderStatus.submitted,
             OrderStatus.inPreparation,
             OrderStatus.ready,
             OrderStatus.delivered,
             OrderStatus.canceled,
           ];

  @override
  State<SegmentedStatusTabsUltra> createState() =>
      _SegmentedStatusTabsUltraState();
}

class _SegmentedStatusTabsUltraState extends State<SegmentedStatusTabsUltra>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fx; // shimmer/breath
  late final List<_TabSpec> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = _buildTabs();
    assert(
      widget.controller.length == _tabs.length,
      'TabController.length (${widget.controller.length}) != tabs (${_tabs.length}). '
      'Use requiredTabsCount() to size your controller.',
    );

    widget.controller.addListener(() {
      if (!widget.controller.indexIsChanging && widget.onChanged != null) {
        widget.onChanged!(_tabs[widget.controller.index].value);
      }
    });

    _fx = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _fx.dispose();
    super.dispose();
  }

  List<_TabSpec> _buildTabs() {
    final out = <_TabSpec>[];
    if (widget.showAll) out.add(_TabSpec(label: 'tabs_all'.tr(), value: null));
    for (final s in widget.order) {
      if (widget.excludeDraft && s == OrderStatus.draft) continue;
      out.add(_TabSpec(label: _statusKey(s).tr(), value: s));
    }
    return out;
  }

@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 8),
      child: SizedBox(
        // <— أهم سطر
        height: 56, // ارتفاع واضح للـ Stack كلّه
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, c) {
              final pillW = (c.maxWidth - 16) / _tabs.length; // 8 + 8 padding
              final anim = widget.controller.animation ?? widget.controller;

              return Stack(
                children: [
                  // خلفية فروستد بارتفاع مضبوط بفضل الـ SizedBox الأب
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(.10),
                            Colors.white.withOpacity(.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEFE4DE)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // Indicator + gloss
                  AnimatedBuilder(
                    animation: anim,
                    builder: (_, __) {
                      final v =
                          (widget.controller.index + widget.controller.offset)
                              .clamp(0.0, (_tabs.length - 1).toDouble());
                      final left = 8 + (v * pillW);
                      return Stack(
                        children: [
                          Positioned(
                            left: left,
                            top: 8,
                            width: pillW,
                            height: 40,
                            child: _SpringyIndicator(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.xprimaryColor,
                                      AppColors.xprimaryColor.withOpacity(.92),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.xprimaryColor
                                          .withOpacity(.35),
                                      blurRadius: 24,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: left,
                            top: 8,
                            width: pillW,
                            height: 40,
                            child: IgnorePointer(
                              child: AnimatedBuilder(
                                animation: _fx,
                                builder: (_, __) {
                                  final t = _fx.value;
                                  return ShaderMask(
                                    shaderCallback: (rect) {
                                      final x = rect.width * (t * 1.2 - .1);
                                      return LinearGradient(
                                        begin: Alignment(-1, 0),
                                        end: Alignment(1, 0),
                                        colors: [
                                          Colors.white.withOpacity(.10),
                                          Colors.white.withOpacity(.45),
                                          Colors.white.withOpacity(.10),
                                        ],
                                        stops: [
                                          ((x - 40) / rect.width).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                          (x / rect.width).clamp(0.0, 1.0),
                                          ((x + 40) / rect.width).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                        ],
                                      ).createShader(rect);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Labels
                  Row(
                    children: List.generate(_tabs.length, (i) {
                      return Expanded(
                        child: _BounceTap(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            widget.controller.animateTo(
                              i,
                              duration: const Duration(milliseconds: 360),
                              curve: Curves.easeOutCubic,
                            );
                          },
                          child: AnimatedBuilder(
                            animation: anim,
                            builder: (_, __) {
                              final dist =
                                  (widget.controller.index +
                                      widget.controller.offset) -
                                  i;
                              final t = (1.0 - dist.abs()).clamp(0.0, 1.0);
                              final selected = t > .5;
                              final color = Color.lerp(
                                AppColors.secondPrimery,
                                Colors.white,
                                t,
                              );
                              final tilt = selected
                                  ? (1 - (dist.abs() * 2)).clamp(0.0, 1.0)
                                  : 0.0;
                              final double scale = 1.0 + (0.04 * tilt);

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(selected ? -.02 : 0)
                                  ..rotateY(selected ? .02 : 0)
                                  ..scale(scale),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 160),
                                    curve: Curves.easeOutCubic,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: selected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      fontSize: AppFontSize.size_14,
                                      letterSpacing: selected ? .2 : 0,
                                    ),
                                    child: Text(
                                      _tabs[i].label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}

class _TabSpec {
  final String label;
  final OrderStatus? value; // null = All
  _TabSpec({required this.label, required this.value});
}

class _BounceTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _BounceTap({required this.child, required this.onTap});
  @override
  State<_BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<_BounceTap> {
  double _scale = 1;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _scale = .965),
      onPointerUp: (_) => setState(() => _scale = 1),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Indicator بارتداد بسيط عند الانتقال (springy edge)
class _SpringyIndicator extends StatefulWidget {
  final Widget child;
  const _SpringyIndicator({required this.child});

  @override
  State<_SpringyIndicator> createState() => _SpringyIndicatorState();
}

class _SpringyIndicatorState extends State<_SpringyIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spring;
  late Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _spring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _curve = CurvedAnimation(parent: _spring, curve: Curves.easeOutBack);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _spring
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SpringyIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _spring
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _spring.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (_, __) {
        final t = _curve.value;
        final scaleX = 1.0 + 0.05 * math.sin(t * math.pi);
        final scaleY = 1.0 + 0.06 * math.sin(t * math.pi);
        return Transform.scale(
          scaleX: scaleX,
          scaleY: scaleY,
          child: widget.child,
        );
      },
    );
  }
}

import 'dart:math' as math;
import 'package:enjaz/features/drink/data/model/drink_model.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/enum/enum.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final String heroTag;
  final DrinkModel drinkModel;

  const CoffeeDetailScreen({
    super.key,
    required this.heroTag,
    required this.drinkModel,
  });

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  String _size = 'M';
  int _qty = 1;
  SugarLevel _sugarLevel = SugarLevel.medium;
  bool _submitting = false;

  double _sugarLevelToPercent(SugarLevel level) {
    switch (level) {
      case SugarLevel.none:
        return 0.0;
      case SugarLevel.light:
        return 0.25;
      case SugarLevel.medium:
        return 0.50;
      case SugarLevel.high:
        return 0.75;
    }
  }

  String get _imageUrl =>
      "https://task.jasim-erp.com/api/dms/file/get/${widget.drinkModel.id}/?entitytype=1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroHeader(
              imageUrl: _imageUrl,
              heroTag: widget.heroTag,
              onBack: () => Navigator.of(context).maybePop(),
              rightIcon: Icons.favorite_border_rounded,
            ),
            const SizedBox(height: 12),

            _ArcSection(
              arcDepth: 36,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.drinkModel.name ?? 'Unknown',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_18,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      widget.drinkModel.description ?? "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_14,
                        color: AppColors.secondPrimery,
                      ),
                    ),

                    const SizedBox(height: 14),

                    SugarAmountSection(
                      color: AppColors.orange,
                      sugarLevel: _sugarLevel,
                      onChanged: (level) => setState(() => _sugarLevel = level), pad: 24.0,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Coffee Size',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_16,
                        color: AppColors.black23,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SizeTile(
                          label: 'Small',
                          selected: _size == 'S',
                          onTap: () => setState(() => _size = 'S'),
                          fillColor: _size == 'S'
                              ? AppColors.orange
                              : Colors.white,
                          borderColor: _size == 'S'
                              ? AppColors.orange
                              : AppColors.orange.withValues(alpha: .35),
                          icon: Icons.local_cafe_outlined,
                          iconColor: _size == 'S'
                              ? Colors.white
                              : AppColors.orange,
                        ),
                        _SizeTile(
                          label: 'Medium',
                          selected: _size == 'M',
                          onTap: () => setState(() => _size = 'M'),
                          fillColor: _size == 'M'
                              ? AppColors.orange
                              : Colors.white,
                          borderColor: _size == 'M'
                              ? AppColors.orange
                              : AppColors.orange.withValues(alpha: .35),
                          icon: Icons.local_cafe_outlined,
                          iconColor: _size == 'M'
                              ? Colors.white
                              : AppColors.orange,
                        ),
                        _SizeTile(
                          label: 'Large',
                          selected: _size == 'L',
                          onTap: () => setState(() => _size = 'L'),
                          fillColor: _size == 'L'
                              ? AppColors.orange
                              : Colors.white,
                          borderColor: _size == 'L'
                              ? AppColors.orange
                              : AppColors.orange.withValues(alpha: .35),
                          icon: Icons.local_cafe_outlined,
                          iconColor: _size == 'L'
                              ? Colors.white
                              : AppColors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6EDE7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF6EDE7)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _MiniCircleBtn(
                            icon: Icons.remove,
                            color: AppColors.orange,
                            onTap: () =>
                                setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                          ),
                          const SizedBox(width: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 160),
                            child: Text(
                              '$_qty',
                              key: ValueKey(_qty),
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_16,
                                color: AppColors.black23,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _MiniCircleBtn(
                            icon: Icons.add,
                            color: AppColors.orange,
                            onTap: () => setState(() => _qty++),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 100,
                    ), // Extra space for the floating button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: _submitting ? null : _addToCart,
          backgroundColor: AppColors.orange,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          label: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Add to Cart',
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: Colors.white,
                  ),
                ),
          icon: _submitting
              ? null
              : const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _addToCart() async {
    setState(() => _submitting = true);

    try {
      final cartItem = CartItemModel(
        drink: widget.drinkModel,
        quantity: _qty,
        size: _size,
        sugarPercentage: _sugarLevelToPercent(_sugarLevel),
      );

      await context.read<CartCubit>().addToCart(cartItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.drinkModel.name} added to cart!'),
            backgroundColor: AppColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add item to cart'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }
}

/// =============================== HEADER ===============================
class _HeroHeader extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final IconData rightIcon;
  final VoidCallback onBack;

  const _HeroHeader({
    required this.imageUrl,
    required this.heroTag,
    required this.onBack,
    required this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Hero(
              tag: heroTag,
              child: CachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
            ),
          ),
          Builder(
            builder: (context) {
              final top = MediaQuery.of(context).padding.top;
              return Stack(
                children: [
                  Positioned(
                    top: top,
                    left: 10,
                    child: _CircleIcon(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: onBack,
                    ),
                  ),
                  Positioned(
                    top: top,
                    right: 10,
                    child: _CircleIcon(icon: rightIcon, onTap: () {}),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ========================= ARC SECTION =========================
class _ArcSection extends StatelessWidget {
  final double arcDepth;
  final Widget child;

  const _ArcSection({required this.child, this.arcDepth = 36});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final bottomBarHeight = 133 + bottomInset;

    return ClipPath(
      clipper: _TopArcClipper(arcDepth: arcDepth),
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF6EDE7),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomBarHeight + 16),
          child: child,
        ),
      ),
    );
  }
}

class _TopArcClipper extends CustomClipper<Path> {
  final double arcDepth;
  const _TopArcClipper({this.arcDepth = 36});

  @override
  Path getClip(Size size) {
    final double d = arcDepth.clamp(12.0, 64.0).toDouble();

    return Path()
      ..lineTo(0.0, d)
      ..quadraticBezierTo(size.width / 2, 0.0, size.width, d)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _TopArcClipper oldClipper) =>
      oldClipper.arcDepth != arcDepth;
}

/// ======================= sugar PERCENT (Arc + Slider) =======================
class SugarAmountSection extends StatelessWidget {
  final Color color;
  final SugarLevel sugarLevel;
  final ValueChanged<SugarLevel> onChanged;
  final double pad;

  const SugarAmountSection({super.key, 
    required this.color,
    required this.sugarLevel,
    required this.onChanged, required this.pad,
  });

  void _updateFromLocal(Offset local, double width) {
    final left = pad;
    final right = width - pad;
    final dx = local.dx.clamp(left, right);
    final t = ((dx - left) / (right - left)).toDouble();

    // Convert percentage to discrete SugarLevel positions
    // Divide the slider into 4 equal sections for 4 enum values
    SugarLevel newLevel;
    if (t <= 0.25) {
      newLevel = SugarLevel.none;
    } else if (t <= 0.50) {
      newLevel = SugarLevel.light;
    } else if (t <= 0.75) {
      newLevel = SugarLevel.medium;
    } else {
      newLevel = SugarLevel.high;
    }

    onChanged(newLevel);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _updateFromLocal(d.localPosition, w),
            onPanDown: (d) => _updateFromLocal(d.localPosition, w),
            onPanUpdate: (d) => _updateFromLocal(d.localPosition, w),
            child: CustomPaint(
              size: Size(w, 110),
              painter: SugarArcPainter(
                color: color,
                sugarLevel: sugarLevel,
                pad: pad,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SugarArcPainter extends CustomPainter {
  final Color color;
  final SugarLevel sugarLevel;
  final double pad;

  SugarArcPainter({
    required this.color,
    required this.sugarLevel,
    this.pad = 24.0,
  });

  double get percent {
    // Map enum values to discrete positions on the slider
    switch (sugarLevel) {
      case SugarLevel.none:
        return 0.0; // 0% position
      case SugarLevel.light:
        return 0.33; // 33% position
      case SugarLevel.medium:
        return 0.67; // 67% position
      case SugarLevel.high:
        return 1.0; // 100% position
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * .70;
    final controlY = size.height * .28;
    final left = Offset(pad, baseY);
    final right = Offset(size.width - pad, baseY);
    final control = Offset(size.width / 2, controlY);

    final path = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(control.dx, control.dy, right.dx, right.dy);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: .25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, trackPaint);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    // Draw discrete position markers for each enum value
    final markerPositions = [
      0.0,
      0.33,
      0.67,
      1.0,
    ]; // Positions for None, Light, Medium, High
    final markerPaint = Paint()
      ..color = color.withValues(alpha: .4)
      ..style = PaintingStyle.fill;

    for (final pos in markerPositions) {
      final tan = metrics.first.getTangentForOffset(metrics.first.length * pos);
      if (tan != null) {
        final p = tan.position;
        canvas.drawCircle(p, 3, markerPaint);
      }
    }

    final m = metrics.first;
    final total = m.length;
    final to = (total * percent.clamp(0.0, 1.0)).clamp(0.0, total);

    final fillPath = m.extractPath(0.0, to);
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(fillPath, fillPaint);

    final tan = m.getTangentForOffset(to);
    if (tan != null) {
      final p = tan.position;
      canvas.drawCircle(
        Offset(p.dx, p.dy + 1.5),
        7,
        Paint()..color = Colors.black12,
      );
      canvas.drawCircle(p, 7, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        7,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color,
      );
    }

    // Get the display name for the sugar level
    String sugarLevelName = _getSugarLevelDisplayName(sugarLevel);
    final tp = TextPainter(
      text: TextSpan(
        text: '$sugarLevelName Sugar',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size.width - tp.width) / 2, size.height * 0.08));
  }

  String _getSugarLevelDisplayName(SugarLevel level) {
    switch (level) {
      case SugarLevel.none:
        return 'No';
      case SugarLevel.light:
        return 'Light';
      case SugarLevel.medium:
        return 'Medium';
      case SugarLevel.high:
        return 'High';
    }
  }

  @override
  bool shouldRepaint(covariant SugarArcPainter old) =>
      old.color != color || old.sugarLevel != sugarLevel || old.pad != pad;
}

/// =============================== SIZE TILE ===============================
class _SizeTile extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color fillColor;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;

  const _SizeTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.fillColor,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<_SizeTile> createState() => _SizeTileState();
}

class _SizeTileState extends State<_SizeTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.selected) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant _SizeTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.selected && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = 16.0;
    final active = widget.selected;
    final bgColor = widget.fillColor;
    final brdColor = widget.borderColor;

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: 82,
            height: 78,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: brdColor, width: 2),
              boxShadow: active
                  ? [
                      BoxShadow(
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                        color: Colors.black12,
                      ),
                    ]
                  : const [],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    tween: Tween(begin: 1.0, end: active ? 1.08 : 1.0),
                    builder: (_, scale, __) => Transform.scale(
                      scale: scale,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          widget.icon,
                          key: ValueKey<Color>(widget.iconColor),
                          color: widget.iconColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                if (active)
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => CustomPaint(
                      painter: _AnimatedBorderPainter(
                        progress: _ctrl.value,
                        stroke: 2.8,
                        radius: radius,
                        colors: const [
                          Color(0xFFFFE4C4),
                          Color(0xFFD95B2B),
                          Color(0xFFFFE4C4),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          style: AppTextStyle.getRegularStyle(
            fontSize: AppFontSize.size_12,
            color: active ? const Color(0xFFD95B2B) : AppColors.secondPrimery,
          ),
          child: Text(widget.label),
        ),
      ],
    );
  }
}

class _AnimatedBorderPainter extends CustomPainter {
  final double progress; // 0..1
  final double stroke;
  final double radius;
  final List<Color> colors;

  _AnimatedBorderPainter({
    required this.progress,
    required this.stroke,
    required this.radius,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final shader = SweepGradient(
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: colors,
      stops: const [0.0, 0.55, 1.0],
      transform: GradientRotation(progress * math.pi * 2),
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..shader = shader;
    final path = Path()..addRRect(rrect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedBorderPainter old) =>
      old.progress != progress ||
      old.stroke != stroke ||
      old.radius != radius ||
      old.colors != colors;
}

// ================================ HELPERS ================================

class _MiniCircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MiniCircleBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black26,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 30,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.white70,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }
}

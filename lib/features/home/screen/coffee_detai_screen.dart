import 'dart:math' as math;
import 'package:enjaz/features/order/data/uscase/create_drink_order_usecase.dart';
import 'package:enjaz/features/order/data/uscase/create_order_item_usecase.dart';
import 'package:enjaz/features/order/screen/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

// ✅ GetModel (fetch details by id)
import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';

// ✅ API model + repo + usecase
import 'package:enjaz/features/home/data/model/coffee_api_model.dart';
import 'package:enjaz/features/home/data/repo/coffee_repository.dart';
import 'package:enjaz/features/home/data/usecase/get_coffee_by_id_usecase.dart';

// ✅ الطلبات
import 'package:enjaz/features/order/cubit/corder_cubit.dart';

class CoffeeDetailScreen extends StatefulWidget {
  const CoffeeDetailScreen({
    super.key,
    required this.floor, // 👈
    required this.office,
    required this.id,
    required this.name,
    required this.heroTag,
  });

  /// GUID من الـ API
  final String id;
  final String name;
  final String heroTag;
  final String floor; // 👈
  final String office;

  /// استدعِها من صفحة القائمة:
  /// CoffeeDetailScreen.routeFromHome(id: coffee.id, name: coffee.name, heroTag: heroTag)
  static Route routeFromHome({
    required String id,
    required String name,
    required String heroTag,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: 'CoffeeDetail:$name'),
      builder: (_) => BlocProvider(
        create: (_) => OrderCubit(),
        child: CoffeeDetailScreen(
          id: id,
          name: name,
          heroTag: heroTag,
          floor: '', // قيم مؤقتة فقط لإرضاء الـ constructor
          office: '',
        ),
      ),
    );
  }

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int? _floor; // انتبه: int?
  final String _office = '';
  String _size = 'M';
  int _qty = 1;
  double _sugarPct = 0.50;
  bool _submitting = false;

  late final _repo = CoffeeRepository();
  late final _getUC = GetCoffeeByIdUseCase(_repo);

  String get _imageUrl =>
      "https://task.jasim-erp.com/api/dms/file/get/${widget.id}/?entitytype=1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      body: GetModel<CoffeeApiModel>(
        useCaseCallBack: () => _getUC(params: GetCoffeeByIdParams(widget.id)),
        modelBuilder: (api) {
          // نبني المحتوى باستخدام بيانات الـ API
          final title = api.name.isNotEmpty ? api.name : widget.name;
          final desc = api.description;
          return _buildContent(title: title, description: desc);
        },
        // في حال الخطأ: عرض محتوى بسيط بالاسم فقط
        onError: (_) => _buildContent(title: widget.name, description: ''),
      ),
    );
  }

  Widget _buildContent({required String title, required String description}) {
    const orange = Color(0xFFD95B2B);

    return SingleChildScrollView(
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
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_18,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),

                  if (description.isNotEmpty)
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_14,
                        color: AppColors.secondPrimery,
                      ),
                    ),

                  const SizedBox(height: 14),

                  _sugarAmountSection(
                    color: orange,
                    percent: _sugarPct,
                    onChanged: (v) => setState(() => _sugarPct = v),
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
                        fillColor: _size == 'S' ? orange : Colors.white,
                        borderColor: _size == 'S'
                            ? orange
                            : orange.withOpacity(.35),
                        icon: Icons.local_cafe_outlined,
                        iconColor: _size == 'S' ? Colors.white : orange,
                      ),
                      _SizeTile(
                        label: 'Medium',
                        selected: _size == 'M',
                        onTap: () => setState(() => _size = 'M'),
                        fillColor: _size == 'M' ? orange : Colors.white,
                        borderColor: _size == 'M'
                            ? orange
                            : orange.withOpacity(.35),
                        icon: Icons.local_cafe_outlined,
                        iconColor: _size == 'M' ? Colors.white : orange,
                      ),
                      _SizeTile(
                        label: 'Large',
                        selected: _size == 'L',
                        onTap: () => setState(() => _size = 'L'),
                        fillColor: _size == 'L' ? orange : Colors.white,
                        borderColor: _size == 'L'
                            ? orange
                            : orange.withOpacity(.35),
                        icon: Icons.local_cafe_outlined,
                        iconColor: _size == 'L' ? Colors.white : orange,
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
                          color: Colors.black.withOpacity(.04),
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
                          color: orange,
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
                          color: orange,
                          onTap: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          _BottomArcBarText(
            // ما عنا سعر بالـ API → بنحط نص بسيط
            priceText: _submitting ? 'Processing...' : 'Ready',
            actionText: _submitting ? 'Please wait' : 'Add to Cart',
            onTap: () async {
              // جهّز القيم اللي بدك تبعتها
              final sugarLevel = (_sugarPct * 3).round().clamp(
                0,
                3,
              ); // لو أنت بالتفاصيل
              final cubit = context.read<OrderCubit>();

              final res = await cubit.addItemToOrder(
                drinkId: widget.id, // أو api.id بالهوم
                quantity: _qty, // أو 1 بالهوم
                sugarLevel: sugarLevel, // احذفها بالهوم لو مش لازمة
                notes: _size, // أو api.name ?? '' بالهوم
              );

              // ✅ بدل res.when(...):
              if (res.hasErrorOnly) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("msg")));
                return;
              }

              // نجاح
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Added to cart')));
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const OrdersScreen()));
            },
            height: 140,
            curveH: 84,
            liftUp: 24,
            contentTopPadding: 45,
            contentBottomPadding: 10,
          ),
        ],
      ),
    );
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
class _sugarAmountSection extends StatelessWidget {
  final Color color;
  final double percent; // 0..1
  final ValueChanged<double> onChanged;
  final double pad;

  const _sugarAmountSection({
    required this.color,
    required this.percent,
    required this.onChanged,
    this.pad = 24.0,
  });

  void _updateFromLocal(Offset local, double width) {
    final left = pad;
    final right = width - pad;
    final dx = local.dx.clamp(left, right);
    final t = ((dx - left) / (right - left)).toDouble();
    onChanged(t.clamp(0.0, 1.0));
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
              painter: _sugarArcPainter(
                color: color,
                percent: percent,
                pad: pad,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _sugarArcPainter extends CustomPainter {
  final Color color;
  final double percent; // 0..1
  final double pad;

  _sugarArcPainter({
    required this.color,
    required this.percent,
    this.pad = 24.0,
  });

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
      ..color = color.withOpacity(.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, trackPaint);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
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

    final tp = TextPainter(
      text: TextSpan(
        text: '${(percent * 100).round()} % Sugar',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size.width - tp.width) / 2, size.height * 0.08));
  }

  @override
  bool shouldRepaint(covariant _sugarArcPainter old) =>
      old.color != color || old.percent != percent || old.pad != pad;
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

/// ============================ BOTTOM TEXT BAR ============================
class _BottomArcBarText extends StatelessWidget {
  final String priceText;
  final String actionText;
  final VoidCallback onTap;

  final double height;
  final double curveH;
  final double liftUp;

  final double contentTopPadding;
  final double contentBottomPadding;

  const _BottomArcBarText({
    required this.priceText,
    required this.actionText,
    required this.onTap,
    this.height = 118,
    this.curveH = 56,
    this.liftUp = 0,
    this.contentTopPadding = 14,
    this.contentBottomPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final totalH = height + bottom;

    final bar = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white10,
        child: SizedBox(
          height: totalH,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _BottomCurvePainter(
                  color: AppColors.xprimaryColor, // كان xpurpleColor
                  curveH: curveH,
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: contentTopPadding,
                    bottom: contentBottomPadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        priceText,
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            actionText,
                            style: AppTextStyle.getBoldStyle(
                              fontSize: AppFontSize.size_18,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: AppFontSize.size_10),
                          const Icon(
                            Iconsax.add_square,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(offset: Offset(0, -liftUp), child: bar),
        SizedBox(height: liftUp),
      ],
    );
  }
}

class _BottomCurvePainter extends CustomPainter {
  final Color color;
  final double curveH;
  const _BottomCurvePainter({required this.color, required this.curveH});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBar = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final double ch = curveH.clamp(10.0, size.height - 1).toDouble();

    final p = Path()
      ..moveTo(0.0, ch)
      ..quadraticBezierTo(w * .5, 0.0, w, ch)
      ..lineTo(w, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    canvas.drawPath(p, paintBar);
  }

  @override
  bool shouldRepaint(covariant _BottomCurvePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.curveH != curveH;
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

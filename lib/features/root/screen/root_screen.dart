import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/features/home/screen/home_screen.dart';
import 'package:enjaz/features/order/screen/orders_screen.dart';
import 'package:enjaz/features/profile/screen/profile_screen.dart';

import '../cubit/root_cubit.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootCubit, RootState>(
      builder: (context, state) {
        final currentIndex = context.read<RootCubit>().rootIndex;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: const [
              CoffeeAppHomeScreen(), // 0
              OrdersScreen(), // 1
              ProfileScreen(), // 2
              // 3
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: _AnimatedNotchedNavBar(
              currentIndex: currentIndex,
              onTap: (i) => context.read<RootCubit>().changePageIndex(i),
              items: const [
                _BarItem(icon: Icons.home_filled, label: 'Home'),
                _BarItem(icon: Icons.local_offer, label: 'Orders'),
                _BarItem(icon: Icons.person_2, label: 'Profile'),
               ],
              barColor: AppColors.xprimaryColor, // بنفسجيك
              accentColor: AppColors.xbackgroundColor, // الدائرة
              curveDepth: 50, // نفس عمق قوس الـCTA
            ),
          ),

          // ألوان مطابقة للنموذج — بدّلها إلى AppColors إن رغبت:
          // barColor: const Color(0xFF2A0C24),
        );
      },
    );
  }
}

// ====================== البيانات ======================

class _BarItem {
  final IconData icon;
  final String label;
  const _BarItem({required this.icon, required this.label});
}

// =================== شريط سفلي متقدّم ===================

class _ArcBarPainter extends CustomPainter {
  final Color color;
  final double barHeight;
  final double depth; // عمق القوس (كل ما كبر زادت الانحناءة)
  final double cornerRadius; // تدوير الزوايا الجانبية

  const _ArcBarPainter({
    required this.color,
    required this.barHeight,
    required this.depth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBar = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final d = depth.clamp(12.0, barHeight - 1.0);
    final r = cornerRadius;
    final w = size.width;
    final h = barHeight;

    final p = Path()
      ..moveTo(0, d)
      ..quadraticBezierTo(w * .5, 0, w, d)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    // حواف جانبية ناعمة فوق (اختياري: بتضيف تفصيل صغير على الأطراف)
    final leftCap = Path()
      ..moveTo(0, d)
      ..quadraticBezierTo(0, d - r, r, d - r)
      ..lineTo(r, d)
      ..close();

    final rightCap = Path()
      ..moveTo(w, d)
      ..quadraticBezierTo(w, d - r, w - r, d - r)
      ..lineTo(w - r, d)
      ..close();

    canvas.drawPath(p, paintBar);
    // إذا بدك الكابات: فكّ التعليقات
    // canvas.drawPath(leftCap, paintBar);
    // canvas.drawPath(rightCap, paintBar);
  }

  @override
  bool shouldRepaint(covariant _ArcBarPainter old) =>
      old.color != color ||
      old.barHeight != barHeight ||
      old.depth != depth ||
      old.cornerRadius != cornerRadius;
}

class _AnimatedNotchedNavBar extends StatefulWidget {
  final int currentIndex;
  final List<_BarItem> items;
  final ValueChanged<int> onTap;

  // تخصيص
  final Color barColor;
  final Color accentColor;
  final double barHeight;
  final double fabSize;
  final double cornerRadius;

  // NEW: عمق القوس العلوي
  final double curveDepth;

  const _AnimatedNotchedNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.barColor = const Color(0xFF2A0C24),
    this.accentColor = const Color(0xFFD95B2B),
    this.barHeight = 72.0,
    this.fabSize = 56.0,
    this.cornerRadius = 24.0,
    this.curveDepth = 86.0, // عدّلها للي بدك ياه
    super.key,
  });

  @override
  State<_AnimatedNotchedNavBar> createState() => _AnimatedNotchedNavBarState();
}

class _AnimatedNotchedNavBarState extends State<_AnimatedNotchedNavBar>
    with SingleTickerProviderStateMixin {
  final _barKey = GlobalKey();
  late List<GlobalKey> _iconKeys;

  late AnimationController _ctrl;
  late Animation<double> _anim; // X للمؤشر
  List<double>? _centers;

  @override
  void initState() {
    super.initState();
    _iconKeys = List.generate(widget.items.length, (_) => GlobalKey());
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _anim = AlwaysStoppedAnimation<double>(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _computeCenters();
      _jumpToIndex(widget.currentIndex);
    });
  }

  @override
  void didUpdateWidget(covariant _AnimatedNotchedNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _centers = null;
      _iconKeys = List.generate(widget.items.length, (_) => GlobalKey());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _computeCenters();
        _animateToIndex(widget.currentIndex);
      });
      return;
    }
    _animateToIndex(widget.currentIndex);
  }

  void _computeCenters() {
    final barBox = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (barBox == null) return;
    final barOrigin = barBox.localToGlobal(Offset.zero);
    final centers = <double>[];
    for (final key in _iconKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final pos = box.localToGlobal(Offset.zero);
      centers.add((pos.dx - barOrigin.dx) + (box.size.width / 2));
    }
    if (centers.length != widget.items.length) {
      final w = barBox.size.width;
      final step = w / (widget.items.length + 1);
      _centers = List.generate(widget.items.length, (i) => step * (i + 1));
    } else {
      _centers = centers;
    }
  }

  void _jumpToIndex(int i) {
    final x = _xForIndex(i);
    _anim = AlwaysStoppedAnimation<double>(x);
    setState(() {});
  }

  void _animateToIndex(int i) {
    final newX = _xForIndex(i);
    if (_anim.value == newX) return;
    _anim = Tween<double>(
      begin: _anim.value,
      end: newX,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl
      ..reset()
      ..forward();
    HapticFeedback.selectionClick();
  }

  double _xForIndex(int index) {
    final barBox = _barKey.currentContext?.findRenderObject() as RenderBox?;
    final w = barBox?.size.width ?? MediaQuery.of(context).size.width;
    return (_centers != null && _centers!.length == widget.items.length)
        ? _centers![index]
        : w * ((index + 1) / (widget.items.length + 1));
  }

  // Y على القوس العلوي عند إحداثي X
  double _yOnArc(double x, double w, double d) {
    // منحنى: (0,d) -> (w/2,0) -> (w,d)
    // معادلة الـBezier التربيعي تبسّطت لـ y = d * (1 - 2x/w + 2(x/w)^2)
    final t = x / w;
    return d * (1 - 2 * t + 2 * t * t);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final barHeight = widget.barHeight + bottom;
    final fabSize = widget.fabSize;

    return SizedBox(
      height: barHeight,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          // X لمركز الدائرة النشطة
          final barBox =
              _barKey.currentContext?.findRenderObject() as RenderBox?;
          final w = barBox?.size.width ?? MediaQuery.of(context).size.width;
          final dipX = (_anim.value == 0)
              ? _xForIndex(widget.currentIndex)
              : _anim.value;

          // احسب موضع Y على القوس وحط الدائرة عليه
          final yArc = _yOnArc(dipX, w, widget.curveDepth);
          final bubbleTop = (yArc - fabSize / 2).clamp(
            0.0,
            barHeight - fabSize,
          );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // خلفية بيضاء تحت الشريط
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(height: barHeight, color: const Color(0xFFF6EDE7),
                  ),
                ),
              ),

              // الشريط بالقوس العلوي
              Positioned.fill(
                child: CustomPaint(
                  key: _barKey,
                  painter: _ArcBarPainter(
                    color: widget.barColor,
                    barHeight: barHeight,
                    depth: widget.curveDepth,
                    cornerRadius: widget.cornerRadius,
                  ),
                ),
              ),

              // الأيقونات
              Positioned.fill(
                top: widget.curveDepth * 0.55, // نزّلهم شوي تحت القوس
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.items.length, (i) {
                    final isActive = i == widget.currentIndex;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onTap(i),
                      child: Padding(
                        key: _iconKeys[i],
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Opacity(
                          opacity: isActive ? 0.0 : 0.9, // نخفيها تحت الدائرة
                          child: Icon(
                            widget.items[i].icon,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // الدائرة النشطة قاعدة على القوس
              Positioned(
                left: dipX - (fabSize / 2),
                top: bubbleTop,
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 6),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      widget.items[widget.currentIndex].icon,
                      key: ValueKey(widget.items[widget.currentIndex].icon),
                      color: AppColors.xprimaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

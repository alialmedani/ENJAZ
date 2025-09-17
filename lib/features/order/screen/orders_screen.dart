// lib/features/order/screen/orders_screen.dart

import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/features/order/cubit/corder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 import 'package:enjaz/features/order/data/model/order_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(),
      child: Scaffold(
        backgroundColor: AppColors.xbackgroundColor2,
        appBar: AppBar(
          backgroundColor: AppColors.xbackgroundColor2,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            'Cart',
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_16,
              color: AppColors.black,
            ),
          ),
        ),
        body: GetModel<List<OrderModel>>(
          useCaseCallBack: () => context.read<OrderCubit>().getOrders(),
          loading: Center(
            child: CircularProgressIndicator(color: AppColors.xprimaryColor),
          ),
          modelBuilder: (orders) {
            final lines = _extractLinesFromOrders(orders);
            if (lines.isEmpty) return const _EmptyCart();
            return _CartBody(lines: lines);
          },
          onError: (_) => const _EmptyCart(),
        ),
      ),
    );
  }
}

/// ========================= helpers: extract lines =========================

List<_CartLine> _extractLinesFromOrders(List<OrderModel> orders) {
  final out = <_CartLine>[];

  for (final o in orders) {
    final dyn = o as dynamic;

    // جرّب نقرأ items أو orderItems
    List<dynamic>? items;
    try {
      items =
          (dyn.items as List<dynamic>?) ?? (dyn.orderItems as List<dynamic>?);
    } catch (_) {
      items = null;
    }

    if (items != null && items.isNotEmpty) {
      for (final it in items) {
        out.add(_CartLine.fromOrderItem(o, it));
      }
    } else {
      // الطلب نفسه يمثل سطر واحد (بعض الـ APIs بترجع عنصر واحد بمستوى الطلب)
      out.add(_CartLine.fromOrder(o));
    }
  }
  return out;
}

/// ====== Line model (قراءة آمنة لعدة أشكال JSON) ======
class _CartLine {
  final OrderModel order;
  final String? orderId;

  final String drinkId; // لعرض الصورة
  final String title; // اسم المشروب
  final String subtitle; // حجم/سكر/ملاحظات
  final double unitPrice; // لو غير موجود = 0
  int qty;

  _CartLine({
    required this.order,
    required this.orderId,
    required this.drinkId,
    required this.title,
    required this.subtitle,
    required this.unitPrice,
    required this.qty,
  });

  static T? _safe<T>(Object? source, T? Function(dynamic d) pick) {
    try {
      final d = source as dynamic;
      return pick(d);
    } catch (_) {
      return null;
    }
  }

  /// الطلب بدون مصفوفة items
  factory _CartLine.fromOrder(OrderModel m) {
    final dyn = m as dynamic;

    final drinkId = _safe<String>(dyn, (d) => d.drinkId as String?) ?? '';

    final title =
        _safe<String>(dyn, (d) => d.drinkName as String?) ??
        _safe<String>(dyn, (d) => d.itemName as String?) ??
        _safe<String>(dyn, (d) => d.name as String?) ??
        'Coffee';

    final size = _safe<String>(dyn, (d) => d.size as String?);
    final sugar = _safe<int>(dyn, (d) => d.sugarLevel as int?);
    final notes = _safe<String>(dyn, (d) => d.notes as String?);

    final subtitle = [
      if (size != null && size.isNotEmpty) 'Size: $size',
      if (sugar != null) 'Sugar: $sugar',
      if (notes != null && notes.isNotEmpty) notes,
    ].join(' • ');

    final qtyNum =
        _safe<num>(dyn, (d) => d.quantity as num?) ??
        _safe<num>(dyn, (d) => d.qty as num?) ??
        1;

    final priceNum =
        _safe<num>(dyn, (d) => d.unitPrice as num?) ??
        _safe<num>(dyn, (d) => d.price as num?) ??
        0;

    final orderId = _safe<String>(dyn, (d) => d.id as String?);

    return _CartLine(
      order: m,
      orderId: orderId,
      drinkId: drinkId,
      title: title,
      subtitle: subtitle.isEmpty ? '—' : subtitle,
      unitPrice: priceNum.toDouble(),
      qty: qtyNum.toInt().clamp(1, 99),
    );
  }

  /// الطلب مع مصفوفة عناصر
  factory _CartLine.fromOrderItem(OrderModel m, dynamic it) {
    final dynIt = it as dynamic;
    final dynOrd = m as dynamic;

    final drinkId =
        _safe<String>(dynIt, (d) => d.drinkId as String?) ??
        _safe<String>(dynIt, (d) => d.itemId as String?) ??
        '';

    final title =
        _safe<String>(dynIt, (d) => d.drinkName as String?) ??
        _safe<String>(dynIt, (d) => d.itemName as String?) ??
        _safe<String>(dynIt, (d) => d.name as String?) ??
        'Coffee';

    final size =
        _safe<String>(dynIt, (d) => d.size as String?) ??
        _safe<String>(dynIt, (d) => d.notes as String?);

    final sugar = _safe<int>(dynIt, (d) => d.sugarLevel as int?);

    final subtitle = [
      if (size != null && size.isNotEmpty) 'Size: $size',
      if (sugar != null) 'Sugar: $sugar',
    ].join(' • ');

    final qtyNum =
        _safe<num>(dynIt, (d) => d.quantity as num?) ??
        _safe<num>(dynIt, (d) => d.qty as num?) ??
        1;

    final priceNum =
        _safe<num>(dynIt, (d) => d.unitPrice as num?) ??
        _safe<num>(dynIt, (d) => d.price as num?) ??
        0;

    final orderId = _safe<String>(dynOrd, (d) => d.id as String?);

    return _CartLine(
      order: m,
      orderId: orderId,
      drinkId: drinkId,
      title: title,
      subtitle: subtitle.isEmpty ? '—' : subtitle,
      unitPrice: priceNum.toDouble(),
      qty: qtyNum.toInt().clamp(1, 99),
    );
  }

  String get imageUrl => drinkId.isEmpty
      ? ''
      : "https://task.jasim-erp.com/api/dms/file/get/$drinkId/?entitytype=1";

  double get lineTotal => unitPrice * qty;
}

/// ============================= Empty Cart =============================
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_cafe_outlined,
              size: 72,
              color: AppColors.xprimaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              'No orders yet',
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_18,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add your first drink to get started',
              textAlign: TextAlign.center,
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.secondPrimery,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.add),
              label: const Text('Browse coffees'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.xprimaryColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =============================== BODY ===============================
class _CartBody extends StatefulWidget {
  final List<_CartLine> lines;
  const _CartBody({required this.lines});

  @override
  State<_CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<_CartBody> {
  double get _subTotal => widget.lines.fold(0.0, (s, e) => s + e.lineTotal);

  @override
  Widget build(BuildContext context) {
    final total = _subTotal;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Order',
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_18,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: AppTextStyle.getRegularStyle(
                      fontSize: AppFontSize.size_12,
                      color: AppColors.secondPrimery,
                    ),
                    children: [
                      const TextSpan(text: 'You have '),
                      TextSpan(
                        text: '${widget.lines.length} items',
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_12,
                          color: const Color(0xFFD95B2B),
                        ),
                      ),
                      const TextSpan(text: ' in your cart.'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // العناصر
                ...List.generate(widget.lines.length, (i) {
                  final line = widget.lines[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CartItemTile(
                      line: line,
                      onQtyChanged: (q) => setState(() => line.qty = q),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // CTA سفلي — السعر ممكن يكون 0 إذا الـ API ما برجع أسعار
          _BottomArcCTA(
            depth: 90,
            curveAtTop: false,
            priceText: '\$${total.toStringAsFixed(2)}',
            buttonText: 'Proceed to Checkout',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Total: \$${total.toStringAsFixed(2)}'),
                  backgroundColor: AppColors.xprimaryColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ============================== Item Tile ==============================
class _CartItemTile extends StatefulWidget {
  final _CartLine line;
  final ValueChanged<int> onQtyChanged;

  const _CartItemTile({required this.line, required this.onQtyChanged});

  @override
  State<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<_CartItemTile> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.line.qty;
  }

  void _setQty(int v) {
    setState(() => _qty = v.clamp(1, 99));
    widget.onQtyChanged(_qty);
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.line;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: line.imageUrl.isNotEmpty
                ? CachedImage(
                    imageUrl: line.imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : _coffeeFallback(),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  line.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.secondPrimery,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  line.unitPrice > 0
                      ? '\$${line.unitPrice.toStringAsFixed(2)}'
                      : '—',
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: AppColors.xorangeColor,
                  ),
                ),
              ],
            ),
          ),

          _MiniQtyChip(value: _qty, onChanged: _setQty),
        ],
      ),
    );
  }

  Widget _coffeeFallback() => Container(
    width: 64,
    height: 64,
    color: AppColors.xprimaryColor.withOpacity(.08),
    child: Icon(Icons.local_cafe, color: AppColors.xprimaryColor),
  );
}

class _MiniQtyChip extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _MiniQtyChip({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconBtn(
            icon: Icons.remove,
            onTap: () => onChanged((value - 1).clamp(1, 99)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$value',
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black,
              ),
            ),
          ),
          _iconBtn(
            icon: Icons.add,
            onTap: () => onChanged((value + 1).clamp(1, 99)),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.xorangeColor),
          color: AppColors.white,
        ),
        child: Icon(icon, size: 16, color: AppColors.xorangeColor),
      ),
    );
  }
}

/// ========================== Arc CTA (قاع الشاشة) ==========================
class _ArcClipper extends CustomClipper<Path> {
  final double depth; // عمق القوس
  final bool curveAtTop; // true= قوس من الأعلى، false= من الأسفل
  const _ArcClipper({this.depth = 90, this.curveAtTop = false});

  @override
  Path getClip(Size size) {
    final d = depth.clamp(20.0, size.height - 1).toDouble();

    if (curveAtTop) {
      // ┌ موجة من الأعلى
      return Path()
        ..lineTo(0, d)
        ..quadraticBezierTo(size.width / 2, 0, size.width, d)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else {
      // └ موجة من الأسفل
      return Path()
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height - d)
        ..quadraticBezierTo(size.width / 2, size.height, 0, size.height - d)
        ..lineTo(0, 0)
        ..close();
    }
  }

  @override
  bool shouldReclip(covariant _ArcClipper old) =>
      old.depth != depth || old.curveAtTop != curveAtTop;
}

class _BottomArcCTA extends StatelessWidget {
  final String priceText;
  final String buttonText;
  final VoidCallback onTap;

  final double depth;
  final bool curveAtTop;

  const _BottomArcCTA({
    required this.priceText,
    required this.buttonText,
    required this.onTap,
    this.depth = 90,
    this.curveAtTop = false,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF2A0C24);

    // لما يكون القوس من تحت، بدنا padding سفلي أكبر
    final EdgeInsets pad = curveAtTop
        ? EdgeInsets.fromLTRB(16, depth, 16, 18)
        : EdgeInsets.fromLTRB(16, 18, 16, depth);

    return ClipPath(
      clipper: _ArcClipper(depth: depth, curveAtTop: curveAtTop),
      child: Container(
        width: double.infinity,
        color: purple,
        padding: pad,
        child: Column(
          children: [
            Text(
              priceText,
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_16,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: AppColors.white,
                ),
                onPressed: onTap,
                child: Text(
                  buttonText,
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

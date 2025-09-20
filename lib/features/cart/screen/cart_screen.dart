import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:enjaz/core/ui/dialogs/dialogs.dart';
import 'package:enjaz/core/ui/widgets/custom_button.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';
import 'package:enjaz/features/order/cubit/order_cubit.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  double _headerProgress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  void _handleScroll() {
    const collapseOffset = 220.0;
    final offset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
    final progress = (offset / collapseOffset).clamp(0.0, 1.0);
    if ((progress - _headerProgress).abs() > 0.01) {
      setState(() => _headerProgress = progress);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.xbackgroundColor3, Colors.white],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: _buildState(context, state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, CartState state) {
    if (state is CartLoading || state is CartInitial) {
      return const Center(
        key: ValueKey('cart-loading'),
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    if (state is CartError) {
      return _ErrorView(
        key: const ValueKey('cart-error'),
        message: state.message,
        onRetry: () => context.read<CartCubit>().loadCart(),
      );
    }

    if (state is CartLoaded) {
      if (state.cartItems.isEmpty) {
        return _EmptyCartView(
          key: const ValueKey('cart-empty'),
          onBrowse: () => Navigator.of(context).maybePop(),
          onRefresh: () => context.read<CartCubit>().loadCart(),
        );
      }
      return _buildLoaded(context, state);
    }

    return const SizedBox(key: ValueKey('cart-idle'));
  }

  Widget _buildLoaded(BuildContext context, CartLoaded state) {
    final items = state.cartItems;
    final totalQuantity = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    // final uniqueDrinks = items
    //     .map((item) => item.drink.id ?? item.drink.name ?? item.drinkId ?? '')
    //     .where((id) => id.trim().isNotEmpty)
    //     .toSet()
    //     .length;
    final sugarVariety = items
        .map((item) => item.sugarPercentage)
        .toSet()
        .length;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Stack(
      key: const ValueKey('cart-loaded'),
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _CartHeader(
                progress: _headerProgress,
                totalItems: state.totalItems,
                totalQuantity: totalQuantity,
                // uniqueDrinks: uniqueDrinks,
                sugarVariety: sugarVariety,
                onClear: () => _showClearCartDialog(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _CartItemCard(
                    item: item,
                    index: index,
                    onQuantityChanged: (value) {
                      context.read<CartCubit>().updateQuantity(
                        item.drink.id ?? '',
                        item.size,
                        item.sugarPercentage,
                        value,
                      );
                    },
                    onRemove: () {
                      context.read<CartCubit>().removeFromCart(
                        item.drink.id ?? '',
                        item.size,
                        item.sugarPercentage,
                      );
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 140 + safeBottom)),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20 + safeBottom,
          child: _CheckoutBar(totalItems: totalQuantity),
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Clear cart',
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_18,
            color: AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to remove every item from your cart?',
          style: AppTextStyle.getRegularStyle(
            fontSize: AppFontSize.size_14,
            color: AppColors.black23,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Clear',
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({
    required this.progress,
    required this.totalItems,
    required this.totalQuantity,
    // required this.uniqueDrinks,
    required this.sugarVariety,
    required this.onClear,
  });

  final double progress;
  final int totalItems;
  final int totalQuantity;
  // final int uniqueDrinks;
  final int sugarVariety;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final collapse = progress.clamp(0.0, 1.0);
    final accent = AppColors.orange;

    return SizedBox(
      height: safeTop + 260,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(
                      accent.withOpacity(0.45),
                      Colors.white,
                      collapse,
                    )!,
                    AppColors.xbackgroundColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: safeTop + 12,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _GlassIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: 1 - collapse,
                    child: Center(
                      child: Text(
                        'Cart',
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_18,
                          color: AppColors.black23,
                        ),
                      ),
                    ),
                  ),
                ),
                _GlassIconButton(icon: Icons.delete_outline, onTap: onClear),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 240),
              opacity: 1 - collapse * 0.9,
              child: Transform.translate(
                offset: Offset(0, 22 * collapse),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order summary',
                            style: AppTextStyle.getBoldStyle(
                              fontSize: AppFontSize.size_16,
                              color: AppColors.black23,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You are moments away from fresh coffee.',
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _MetricChip(
                                icon: Icons.coffee_outlined,
                                label: 'Items',
                                value: '$totalItems',
                              ),
                              _MetricChip(
                                icon: Icons.local_drink_outlined,
                                label: 'Total cups',
                                value: '$totalQuantity',
                              ),
                              // _MetricChip(
                              //   icon: Icons.inventory_outlined,
                              //   label: 'Unique drinks',
                              //   value: '$uniqueDrinks',
                              // ),
                              _MetricChip(
                                icon: Icons.water_drop_outlined,
                                label: 'Sugar sets',
                                value: '$sugarVariety',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItemModel item;
  final int index;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final alias = (item.drink.name ?? item.drink.id ?? '?').trim().isNotEmpty
        ? (item.drink.name ?? item.drink.id ?? '?').trim()[0].toUpperCase()
        : '?';
    final sugarLabel = _sugarLevelLabel(
      _percentageToSugarLevel(item.sugarPercentage),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.greyE5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 86,
                  height: 86,
                  child: CachedImage(
                    imageUrl:
                        'https://task.jasim-erp.com/api/dms/file/get/${item.drink.id}/?entitytype=1',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.drink.name ?? 'Unknown drink',
                                style: AppTextStyle.getBoldStyle(
                                  fontSize: AppFontSize.size_16,
                                  color: AppColors.black23,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Size ${item.size} | Sugar $sugarLabel',
                                style: AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_12,
                                  color: AppColors.secondPrimery,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.close_rounded, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 32,
                          ),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _QuantityControl(
                          quantity: item.quantity,
                          onDecrement: item.quantity > 1
                              ? () => onQuantityChanged(item.quantity - 1)
                              : null,
                          onIncrement: () =>
                              onQuantityChanged(item.quantity + 1),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.xbackgroundColor3,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.orange.withOpacity(0.18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  alias,
                                  style: AppTextStyle.getBoldStyle(
                                    fontSize: AppFontSize.size_12,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sugar $sugarLabel',
                                style: AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_12,
                                  color: AppColors.black23,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityButton(icon: Icons.remove_rounded, onTap: onDecrement),
        const SizedBox(width: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            '$quantity',
            key: ValueKey<int>(quantity),
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_16,
              color: AppColors.black23,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _QuantityButton(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.4 : 1,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView({
    super.key,
    required this.onBrowse,
    required this.onRefresh,
  });

  final VoidCallback onBrowse;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.xbackgroundColor3,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 54,
                color: AppColors.orange.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is feeling light',
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_18,
                color: AppColors.black23,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Explore drinks and add them here to build your perfect order.',
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_13,
                color: AppColors.secondPrimery,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: onRefresh,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.orange,
                    side: BorderSide(color: AppColors.orange.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Refresh'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onBrowse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Browse drinks'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.orange.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.totalItems});

  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 20,
                    color: AppColors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Total cups in cart',
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_13,
                        color: AppColors.black23,
                      ),
                    ),
                  ),
                  Text(
                    '$totalItems',
                    style: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_18,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CreateModel<OrderModel>(
                onSuccess: (_) {
                  Dialogs.showSnackBar(message: 'Successfully placed order');
                  context.read<CartCubit>().clearCart();
                },
                withValidation: false,
                useCaseCallBack: (data) =>
                    context.read<OrderCubit>().requestOrder(),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    color: AppColors.orange,
                    text: 'Proceed to checkout',
                    textStyle: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withOpacity(0.7),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, size: 20, color: AppColors.black23),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.orange),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_13,
                  color: AppColors.black23,
                ),
              ),
              Text(
                label,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_10,
                  color: AppColors.secondPrimery,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

SugarLevel _percentageToSugarLevel(double value) {
  if (value <= 0) return SugarLevel.none;
  if (value <= 0.25) return SugarLevel.light;
  if (value <= 0.5) return SugarLevel.medium;
  return SugarLevel.high;
}

String _sugarLevelLabel(SugarLevel level) {
  switch (level) {
    case SugarLevel.none:
      return 'None';
    case SugarLevel.light:
      return 'Light';
    case SugarLevel.medium:
      return 'Medium';
    case SugarLevel.high:
      return 'High';
  }
}

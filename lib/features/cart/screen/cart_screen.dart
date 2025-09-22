import 'dart:ui';
import 'package:enjaz/features/cart/screen/widget/cart_header.dart';
import 'package:enjaz/features/cart/screen/widget/cart_item_card.dart';
import 'package:enjaz/features/cart/screen/widget/checkout_bar.dart';
import 'package:enjaz/features/cart/screen/widget/empty_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';

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
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _CartBackground(progress: _headerProgress),
          SafeArea(
            top: false,
            bottom: false,
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: _buildState(context, state),
              ),
            ),
          ),
        ],
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
      return ErrorView(
        key: const ValueKey('cart-error'),
        message: state.message,
        onRetry: () => context.read<CartCubit>().loadCart(),
      );
    }

    if (state is CartLoaded) {
      if (state.cartItems.isEmpty) {
        return EmptyCartView(
          key: const ValueKey('cart-empty'),
          onBrowse: () => Navigator.of(context).maybePop(),
          onRefresh: () => context.read<CartCubit>().loadCart(),
        );
      }

      final items = state.cartItems;
      final totalQuantity = items.fold<int>(0, (sum, it) => sum + it.quantity);
      final sugarVariety = items.map((it) => it.sugarPercentage).toSet().length;
      final safeBottom = MediaQuery.of(context).padding.bottom;

      return Stack(
        key: const ValueKey('cart-loaded'),
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: CartHeader(
                  progress: _headerProgress,
                  totalItems: state.totalItems,
                  totalQuantity: totalQuantity,
                  sugarVariety: sugarVariety,
                  onClear: () => _showClearCartDialog(context),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) => CartItemCard(
                    item: items[index],
                    index: index,
                    onQuantityChanged: (value) {
                      context.read<CartCubit>().updateQuantity(
                        items[index].drink.id ?? '',
                        items[index].size,
                        items[index].sugarPercentage,
                        value,
                      );
                    },
                    onRemove: () {
                      context.read<CartCubit>().removeFromCart(
                        items[index].drink.id ?? '',
                        items[index].size,
                        items[index].sugarPercentage,
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 220 + safeBottom)),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20 + safeBottom,
            child: CheckoutBar(
              totalItems: totalQuantity,
              onCheckoutComplete: () => context.read<CartCubit>().clearCart(),
            ),
          ),
        ],
      );
    }

    return const SizedBox(key: ValueKey('cart-idle'));
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => const _ClearDialog(),
    );
  }
}

class _CartBackground extends StatelessWidget {
  const _CartBackground({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.orange;
    final topColor = Color.lerp(
      accent.withValues(alpha: 0.48),
      AppColors.xbackgroundColor3,
      progress,
    )!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutQuart,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, Colors.white],
        ),
      ),
      child: IgnorePointer(
        ignoring: true,
        child: Stack(
          children: [
            Positioned(
              top: -120 + (progress * 70),
              right: -40,
              child: _BlurredOrb(
                size: 220,
                colors: [
                  accent.withValues(alpha: 0.36),
                  AppColors.xbackgroundColor.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              top: 220,
              left: -60,
              child: _BlurredOrb(
                size: 280,
                colors: [
                  AppColors.secondPrimery.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
            Positioned(
              bottom: -140,
              right: -80,
              child: _BlurredOrb(
                size: 320,
                colors: [accent.withValues(alpha: 0.24), Colors.transparent],
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.28, 1.0],
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.16),
                      Colors.white,
                    ],
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

class _BlurredOrb extends StatelessWidget {
  const _BlurredOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: size * 0.08, sigmaY: size * 0.08),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}

class _ClearDialog extends StatelessWidget {
  const _ClearDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('cart_clear_title'.tr()), // "Clear cart"
      content: Text('cart_clear_body'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common_cancel'.tr()),
        ),
        TextButton(
          onPressed: () {
            context.read<CartCubit>().clearCart();
            Navigator.of(context).pop();
          },
          child: Text(
            'cart_clear_action'.tr(), // "Clear"
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

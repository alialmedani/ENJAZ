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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              SliverToBoxAdapter(child: SizedBox(height: 210 + safeBottom)),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20 + safeBottom,
            child: CheckoutBar(totalItems: totalQuantity),
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

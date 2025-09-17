import 'package:enjaz/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:enjaz/core/ui/widgets/custom_button.dart';
import 'package:enjaz/features/cart/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cart',
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_20,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showClearCartDialog(context),
            icon: const Icon(Icons.delete_outline),
            color: AppColors.orange,
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            );
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppTextStyle.getRegularStyle(
                      fontSize: AppFontSize.size_16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CartCubit>().loadCart(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        cartItem: state.cartItems[index],
                        onQuantityChanged: (newQuantity) {
                          final item = state.cartItems[index];
                          context.read<CartCubit>().updateQuantity(
                            item.drink.id!,
                            item.size,
                            item.sugarPercentage,
                            newQuantity,
                          );
                        },
                        onRemove: () {
                          final item = state.cartItems[index];
                          context.read<CartCubit>().removeFromCart(
                            item.drink.id!,
                            item.size,
                            item.sugarPercentage,
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildCartSummary(context, state.cartItems),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.orange.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_20,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious drinks to get started!',
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.secondPrimery,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(
    BuildContext context,
    List<CartItemModel> cartItems,
  ) {
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color: AppColors.black,
                ),
              ),
              Text(
                '$totalItems',
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CreateModel<OrderModel>(
              withValidation: false,
              useCaseCallBack: (data) {
                return context.read<CartCubit>().requestOrder();
              },
              child: CustomButton(
                color: AppColors.orange,
                text: 'Proceed to Checkout',
                textStyle: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Cart',
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_18,
            color: AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all items from your cart?',
          style: AppTextStyle.getRegularStyle(
            fontSize: AppFontSize.size_14,
            color: AppColors.black23,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
              Navigator.of(context).pop();
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

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: CachedImage(
                imageUrl:
                    "https://task.jasim-erp.com/api/dms/file/get/${cartItem.drink.id}/?entitytype=1",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.drink.name ?? 'Unknown',
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${cartItem.size} • Sugar: ${(cartItem.sugarPercentage * 100).toInt()}%',
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.secondPrimery,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: () {
                        if (cartItem.quantity > 1) {
                          onQuantityChanged(cartItem.quantity - 1);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${cartItem.quantity}',
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_16,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () => onQuantityChanged(cartItem.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
            color: Colors.red[400],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

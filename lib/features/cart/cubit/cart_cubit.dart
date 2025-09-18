import 'package:bloc/bloc.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';
import 'package:meta/meta.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  // Helper method to convert percentage to SugarLevel enum


  void loadCart() {
    try {
      emit(CartLoading());
      final cartItems = CacheHelper.getCartItems();
      final totalItems = CacheHelper.cartItemCount;
      emit(CartLoaded(cartItems: cartItems, totalItems: totalItems));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> addToCart(CartItemModel cartItem) async {
    try {
      await CacheHelper.addToCart(cartItem);
      loadCart(); // Reload cart to update UI
    } catch (e) {
      emit(CartError('Failed to add item to cart: ${e.toString()}'));
    }
  }

  Future<void> removeFromCart(
    String drinkId,
    String size,
    double sugarPercentage,
  ) async {
    try {
      await CacheHelper.removeFromCart(drinkId, size, sugarPercentage);
      loadCart(); // Reload cart to update UI
    } catch (e) {
      emit(CartError('Failed to remove item from cart: ${e.toString()}'));
    }
  }

  Future<void> updateQuantity(
    String drinkId,
    String size,
    double sugarPercentage,
    int newQuantity,
  ) async {
    try {
      await CacheHelper.updateCartItemQuantity(
        drinkId,
        size,
        sugarPercentage,
        newQuantity,
      );
      loadCart(); // Reload cart to update UI
    } catch (e) {
      emit(CartError('Failed to update item quantity: ${e.toString()}'));
    }
  }

  Future<void> clearCart() async {
    try {
      await CacheHelper.clearCart();
      loadCart(); // Reload cart to update UI
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }


}

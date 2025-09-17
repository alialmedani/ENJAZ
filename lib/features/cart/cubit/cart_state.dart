part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItemModel> cartItems;
  final int totalItems;

  CartLoaded({required this.cartItems, required this.totalItems});
}

final class CartError extends CartState {
  final String message;

  CartError(this.message);
}

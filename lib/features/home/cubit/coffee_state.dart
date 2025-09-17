import '../data/model/coffee_api_model.dart';

abstract class CoffeeState {}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeError extends CoffeeState {
  final String message;
  CoffeeError(this.message);
}

class CoffeeSuccess extends CoffeeState {
  final List<CoffeeApiModel> items;
  CoffeeSuccess(this.items);
}

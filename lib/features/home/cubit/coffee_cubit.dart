import 'package:flutter_bloc/flutter_bloc.dart';

import 'coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit() : super(CoffeeInitial());
}

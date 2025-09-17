import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../core/results/result.dart';
import '../data/repository/drink_repository.dart';
import '../data/usecase/get_all_drink_usecase.dart';
part 'drink_state.dart';

class DrinkCubit extends Cubit<DrinkState> {
  PaginationCubit? drinkCubit;

  DrinkCubit() : super(DrinkInitial());

  Future<Result> fetchAllDrinkServies(data) async {
    return await GetAllDrinkUsecase(
      DrinkRepository(),
    ).call(params: GetAllDrinkParams(request: data));
  }
}

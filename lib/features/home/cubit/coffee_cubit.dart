import 'package:enjaz/features/home/data/usecase/coffee_list_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/results/result.dart';

// لو مسار الريبو عندك تحت repo/ خليه كما هو:
import 'package:enjaz/features/home/data/repo/coffee_repository.dart';

// Params (Create/Update) + CoffeeListParams adapter
import 'package:enjaz/features/home/data/usecase/coffee_api_params.dart';

// موديل الـ API + المحوّل للـ UI
import '../data/model/coffee_api_model.dart';

// اليوزكيز
import '../data/usecase/list_coffees_usecase.dart';
import '../data/usecase/create_coffee_usecase.dart';
  
// لو بدك تدعم PaginationList مباشرة:
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';

import 'coffee_state.dart';
 // احذف: CoffeeUiAdapter/CoffeeUi

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit() : super(CoffeeInitial());

  final CoffeeRepository _repo = CoffeeRepository();
  late final ListCoffeesUseCase _listUC = ListCoffeesUseCase(_repo);
  late final CreateCoffeeUseCase _createUC = CreateCoffeeUseCase(_repo);

  Future<void> load({int page = 1, int pageSize = 20}) async {
    emit(CoffeeLoading());
    final skip = (page - 1) * pageSize;
    final params = CoffeeListParams(skip: skip, take: pageSize);

    final res = await _listUC(params: params);
    if (res.hasErrorOnly) {
      emit(CoffeeError(res.error ?? 'Unexpected error'));
      return;
    }

    final data = res.data ?? const <CoffeeApiModel>[];
    emit(CoffeeSuccess(data)); // ← مباشرة
  }

  Future<void> loadPaged(GetListRequest r) async {
    emit(CoffeeLoading());
    final params = CoffeeListParams.fromGetList(r);
    final res = await _listUC(params: params);
    if (res.hasErrorOnly) {
      emit(CoffeeError(res.error ?? 'Unexpected error'));
      return;
    }
    final data = res.data ?? const <CoffeeApiModel>[];
    emit(CoffeeSuccess(data)); // ← مباشرة
  }

  Future<Result> create(String name, String description, int sugar) {
    return _createUC(
      params: CreateCoffeeParams(
        name: name,
        description: description,
        sugar: sugar,
      ),
    );
  }
}

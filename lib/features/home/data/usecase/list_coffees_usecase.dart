// lib/features/home/data/usecase/list_coffees_usecase.dart
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/home/data/model/coffee_api_model.dart';
import 'package:enjaz/features/home/data/repo/coffee_repository.dart';
 import 'package:enjaz/features/home/data/usecase/coffee_list_params.dart';

class ListCoffeesUseCase
    extends UseCase<List<CoffeeApiModel>, CoffeeListParams> {
  final CoffeeRepository repo;
  ListCoffeesUseCase(this.repo);

  @override
  Future<Result<List<CoffeeApiModel>>> call({
    required CoffeeListParams params,
  }) {
    return repo.listCoffees(params: params);
  }
}

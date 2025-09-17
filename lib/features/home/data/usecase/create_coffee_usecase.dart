import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/home/data/repo/coffee_repository.dart';
import 'package:enjaz/features/home/data/usecase/coffee_api_params.dart';
import '../model/coffee_api_model.dart';
  
class CreateCoffeeUseCase extends UseCase<CoffeeApiModel, CreateCoffeeParams> {
  final CoffeeRepository repo;
  CreateCoffeeUseCase(this.repo);

  @override
  Future<Result<CoffeeApiModel>> call({required CreateCoffeeParams params}) {
    return repo.createCoffee(params: params);
  }
}

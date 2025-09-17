import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/home/data/model/coffee_api_model.dart';
import 'package:enjaz/features/home/data/repo/coffee_repository.dart';

class GetCoffeeByIdParams extends BaseParams {
  final String id; // ⚠️ الـ API بيرجع GUID => String
  GetCoffeeByIdParams(this.id);
}

class GetCoffeeByIdUseCase
    extends UseCase<CoffeeApiModel, GetCoffeeByIdParams> {
  final CoffeeRepository repo;
  GetCoffeeByIdUseCase(this.repo);

  @override
  Future<Result<CoffeeApiModel>> call({required GetCoffeeByIdParams params}) {
    return repo.getCoffeeById(id: params.id);
  }
}

// import 'package:enjaz/core/params/base_params.dart';
// import 'package:enjaz/core/results/result.dart';
// import 'package:enjaz/core/usecase/usecase.dart';
// import 'package:enjaz/features/home/data/repo/coffee_repository.dart';
 
// class DeleteCoffeeParams extends BaseParams {
//   final int id;
//   DeleteCoffeeParams(this.id);
// }

// class DeleteCoffeeUseCase extends UseCase<String, DeleteCoffeeParams> {
//   final CoffeeRepository repo;
//   DeleteCoffeeUseCase(this.repo);

//   @override
//   Future<Result<String>> call({required DeleteCoffeeParams params}) {
//     return repo.deleteCoffee(id: params.id);
//   }
// }

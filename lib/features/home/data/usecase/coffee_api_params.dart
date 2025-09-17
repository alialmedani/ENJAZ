import 'package:enjaz/core/params/base_params.dart';

class CreateCoffeeParams extends BaseParams {
  final String name;
  final String description;
  final int sugar;

  CreateCoffeeParams({
    required this.name,
    required this.description,
    required this.sugar,
  });

  Map<String, dynamic> toJson() => {
    'name': name.trim(),
    'description': description.trim(),
    'sugar': sugar,
  };
}

class UpdateCoffeeParams extends BaseParams {
  final int id;
  final String name;
  final String description;
  final int sugar;

  UpdateCoffeeParams({
    required this.id,
    required this.name,
    required this.description,
    required this.sugar,
  });

  Map<String, dynamic> toJson() => {
    'name': name.trim(),
    'description': description.trim(),
    'sugar': sugar,
  };
}

class ListCoffeesParams extends BaseParams {
  final int page; // إن لم يكن هناك pagination تجاهلها
  final int pageSize; // كذلك
  ListCoffeesParams({this.page = 1, this.pageSize = 20});

  Map<String, dynamic> toQuery() => {'page': page, 'pageSize': pageSize};
}

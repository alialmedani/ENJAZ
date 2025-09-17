
import '../../../../core/params/base_params.dart';

class CreateOrderItemParams extends BaseParams {
  String drinkId;
  int sugarLevel;
  int quantity;
  String notes;

  CreateOrderItemParams({
    required this.drinkId,
    required this.sugarLevel,
    required this.quantity,
    required this.notes,
  
  });

  toJson() {
    return {
      "drinkId": drinkId,
      "sugarLevel": sugarLevel,
      "quantity": quantity,
      "notes": notes,
    };
  }
}




import 'package:enjaz/core/constant/enum/enum.dart';

class UpdateOrderStatusRequest {
    String orderId;
 OrderStatus status;

  UpdateOrderStatusRequest({required this.orderId, required this.status});

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'status': status,
  };
}


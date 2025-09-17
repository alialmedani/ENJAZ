// // lib/features/order/data/model/params/create_order_params.dart
// import 'package:intl/intl.dart';

// class CreateOrderParams {
//   String itemName = '';
//   String size = 'M';
//   String buyerName = '';
//   int floor = 1;
//   int office = 1;

//   // إضافات متقدمة:
//   int quantity = 1;
//   String sugarLevel = 'normal'; // من SugarLevelX.value
//   String milkType = 'regular'; // من MilkTypeX.value
//   String temperature = 'hot'; // من TemperatureX.value
//   List<String> extras = <String>[];
//   String? note;
//   DateTime? scheduledAt; // null => الآن

//   Map<String, dynamic> toMap() => {
//     'itemName': itemName,
//     'size': size,
//     'buyerName': buyerName,
//     'floor': floor,
//     'office': office,
//     'quantity': quantity,
//     'sugarLevel': sugarLevel,
//     'milkType': milkType,
//     'temperature': temperature,
//     'extras': extras,
//     'note': note,
//     'scheduledAt': scheduledAt != null
//         ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(scheduledAt!.toLocal())
//         : null,
//   };
// }

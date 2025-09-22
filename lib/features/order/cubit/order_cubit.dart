import 'package:bloc/bloc.dart';
import 'package:enjaz/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:meta/meta.dart';

import '../../../core/classes/cashe_helper.dart';
import '../../../core/constant/enum/enum.dart';
import '../../../core/results/result.dart';
import '../../cart/data/model/create_item_model.dart';
import '../data/repository/order_repo.dart';
import '../data/usecase/create_order_usecase.dart';
import '../data/usecase/get_all_order_usecase.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  PaginationCubit? orderCubit;
  OrderCubit() : super(OrderInitial());

  // --- تخزين اختيار المكان (الطابق والمكتب) ---
  String? _floorId;
  String? _officeId;

  void setDeliveryPlace({required String floorId, required String officeId}) {
    _floorId = floorId;
    _officeId = officeId;
  }

  bool get hasValidPlace =>
      (_floorId != null && _floorId!.isNotEmpty) &&
      (_officeId != null && _officeId!.isNotEmpty);

  SugarLevel _percentageToSugarLevel(double percentage) {
    if (percentage <= 0.0) return SugarLevel.none;
    if (percentage <= 0.25) return SugarLevel.light;
    if (percentage <= 0.50) return SugarLevel.medium;
    return SugarLevel.high;
  }

  CreateOrderParams get createOrderParams => CreateOrderParams(
    orderItems: CacheHelper.getCartItems().map((cartItem) {
      return CreateItemModel(
        drinkId: cartItem.drink.id ?? "",
        quantity: cartItem.quantity,
        notes: "",
        sugarLevel: _percentageToSugarLevel(cartItem.sugarPercentage).toInt(),
      );
    }).toList(),
    floorId: _floorId ?? '', // ← تعبئة من الاختيار المخزّن
    officeId: _officeId ?? '', // ← تعبئة من الاختيار المخزّن
  );

  Future<Result> requestOrder() async {
    return await CreateOrderUsecase(
      OrderRepository(),
    ).call(params: createOrderParams);
  }

  Future<Result> fetchAllOrder(data) async {
    return await GetAllOrdersUsecase(
      OrderRepository(),
    ).call(params: GetAllOrdersParams(request: data));
  }
}

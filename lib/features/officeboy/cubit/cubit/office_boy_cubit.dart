import 'package:bloc/bloc.dart';
import 'package:enjaz/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/core/constant/enum/enum.dart' as Core;
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/cart/data/model/create_item_model.dart';
import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';
import 'package:enjaz/features/officeboy/data/model/status_order_model.dart';
import 'package:enjaz/features/officeboy/data/repo/office_boy_repo.dart';
import 'package:enjaz/features/officeboy/data/usecase/get_order_usecase.dart';
import 'package:enjaz/features/officeboy/data/usecase/status_order_usecase.dart';
import 'package:meta/meta.dart';

part 'office_boy_state.dart';

class OfficeBoyCubit extends Cubit<OfficeBoyState> {
  PaginationCubit? drinkCubit;

  OfficeBoyCubit() : super(OfficeBoyInitial());
  final OfficeBoyRepository _repo = OfficeBoyRepository();

  Future<Result<List<OfficeBoyModel>>> fetchAllOrderServies(
    GetListRequest data,
  ) async {
    return await GetOrderOfficeBoyUsecase(
      OfficeBoyRepository(),
    ).call(params: GetOrderOfficeBoyParams(request: data));
  }
Future<Result<SatusOrderModel>> updateOrderStatus({
    required String orderId,
    required Core.OrderStatus status,
  }) async {
    try {
      final usecase = UpdateOrderStatusUsecase(_repo);
      final res = await usecase.call(
        params: UpdateOrderStatusParams(
          orderId: orderId,
          status: status, // toJson جوّا الـ Params بتحوّلها لـ int
        ),
      );
      // res هو Result<SatusOrderModel>
      return res;
    } catch (e) {
      // رجّع Result بخطأ بدل ما ترمي Exception
      return Result<SatusOrderModel>(error: e.toString());
    }
  }

  /// 2) نسخة بسيطة ترجع bool — مريحة للأزرار/الـ UI
  Future<bool> updateOrderStatusBool({
    required String orderId,
    required Core.OrderStatus status,
  }) async {
    final res = await updateOrderStatus(orderId: orderId, status: status);
    return res.hasDataOnly;
  }

  // UpdateOrderStatusParams get createOrderSatusrParams => UpdateOrderStatusParams(
  //   orderItems: CacheHelper.getCartItems().map((cartItem) {
  //     return UpdateOrderStatusUsecase(
  //      "orderId": orderId,
  //   "status": status.toInt(),
  //       // sugarLevel: _percentageToSugarLevel(cartItem.sugarPercentage).toInt(),
  //     );
  //   }).toList(),
  //   floorId: _floorId ?? '', // ← تعبئة من الاختيار المخزّن
  //   officeId: _officeId ?? '', // ← تعبئة من الاختيار المخزّن
  // );
  //   Future<Result> requestOrder() async {
  //   return await UpdateOrderStatusUsecase(
  //     OfficeBoyRepository(),
  //   ).call(params: createOrderSatusrParams);
  // }
}

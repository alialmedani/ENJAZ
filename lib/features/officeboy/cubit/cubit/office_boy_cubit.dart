 import 'package:bloc/bloc.dart';
import 'package:enjaz/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';
import 'package:enjaz/features/officeboy/data/repo/office_boy_repo.dart';
import 'package:enjaz/features/officeboy/data/usecase/get_order_usecase.dart';
import 'package:enjaz/features/officeboy/data/usecase/status_order_usecase.dart';
import 'package:meta/meta.dart';

import '../../../../core/boilerplate/pagination/models/get_list_request.dart';
part 'office_boy_state.dart';

class OfficeBoyCubit extends Cubit<OfficeBoyState> {
  PaginationCubit? drinkCubit;

  OfficeBoyCubit() : super(OfficeBoyInitial());

  GetOrderOfficeBoyParams getOrderOfficeBoyParams = GetOrderOfficeBoyParams(
    request: GetListRequest(),
    status: 0,
  );

  Future<Result<List<OfficeBoyModel>>> fetchAllOrderServies(data) async {
    return await GetOrderOfficeBoyUsecase(
      OfficeBoyRepository(),
    ).call(params: getOrderOfficeBoyParams);
  }

  UpdateOrderStatusParams updateOrderStatusParams = UpdateOrderStatusParams(
    orderId: '',
    status: 0,
  );

  Future<Result> updateOrderStatusBool() async {
    final res = await UpdateOrderStatusUsecase(
      OfficeBoyRepository(),
    ).call(params: updateOrderStatusParams);
    return res;
  } 
}
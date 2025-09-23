import 'package:bloc/bloc.dart';
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/place/data/repo/place_repository.dart';
import 'package:enjaz/features/place/data/usecase/get_place_usecase.dart';
import 'package:meta/meta.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit() : super(PlaceInitial());


  GetPlaceParam getPlaceParam = GetPlaceParam(
    request: GetListRequest(),
    type: 0,
  );
  Future<Result> fetchPLaceServies(data) async {
    return await GetPlacekUsecase(
      PlaceRepository(),
    ).call(params: getPlaceParam);
  }
}

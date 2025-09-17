// lib/features/home/data/usecase/coffee_api_params.dart
import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';

class CoffeeListParams extends BaseParams {
  final int? skip;
  final int? take;
  final String? search;

  CoffeeListParams({this.skip, this.take, this.search});

  factory CoffeeListParams.fromGetList(GetListRequest r) =>
      CoffeeListParams(skip: r.skip, take: r.take,  );

  Map<String, dynamic> toQuery() => {
    if (skip != null) 'skip': skip,
    if (take != null && take! > 0) 'take': take,
    if (search != null && search!.isNotEmpty) 'search': search,
  };

  // لو APIك يستخدم page/pageSize بدال skip/take:
  // Map<String, dynamic> toQuery() {
  //   final ps = (take ?? 10);
  //   final pg = ((skip ?? 0) ~/ ps) + 1;
  //   return {'page': pg, 'pageSize': ps, if (search?.isNotEmpty == true) 'search': search};
  // }
}

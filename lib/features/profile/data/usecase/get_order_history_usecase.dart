// lib/features/profile/data/usecase/get_order_history_usecase.dart
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/order_history_entry.dart';
import 'package:enjaz/features/profile/data/repo/profile_repository.dart';
 
class GetOrderHistoryUsecase {
  final ProfileRepository repo;
  GetOrderHistoryUsecase(this.repo);

  Future<Result<List<OrderHistoryEntry>>> call({DateTime? month}) async {
    final all = await repo.getHistory();
    if (!all.hasDataOnly) return all;

    if (month == null) {
      return Result<List<OrderHistoryEntry>>(data: all.data);
    }

    final y = month.year, m = month.month;
    final filtered = all.data!
        .where((e) => e.createdAt.year == y && e.createdAt.month == m)
        .toList();

    return Result<List<OrderHistoryEntry>>(data: filtered);
  }
}

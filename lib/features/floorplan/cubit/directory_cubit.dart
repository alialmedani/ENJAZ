import 'package:bloc/bloc.dart';
import 'package:enjaz/features/floorplan/data/model/directory_item_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';
import 'package:enjaz/features/floorplan/data/usecase/department_autocomplete.dart';
import 'package:enjaz/features/floorplan/data/usecase/search_directory.dart';
import 'package:meta/meta.dart';

part 'directory_state.dart';

class DirectoryCubit extends Cubit<DirectoryState> {
  DirectoryCubit() : super(DirectoryInitial());

  final FloorplanRepository _repository = FloorplanRepository();

  static const int _pageSize = 20;

  // Current filters.
  String _text = '';
  String? _departmentId;
  String? _floorId;
  int? _type; // DirectoryItemType int or null = all.

  final List<DirectoryItemModel> _items = [];
  int _totalCount = 0;
  bool _loadingMore = false;

  int get type => _type ?? 0;

  /// Resets and runs a fresh search with the given filters.
  Future<void> search({
    String? text,
    String? departmentId,
    String? floorId,
    int? type,
  }) async {
    _text = text ?? _text;
    _departmentId = departmentId;
    _floorId = floorId;
    _type = type;
    _items.clear();
    _totalCount = 0;

    emit(DirectoryLoading());
    await _fetch(reset: true);
  }

  /// Loads the next page if there are more results.
  Future<void> loadMore() async {
    if (_loadingMore) return;
    if (_items.length >= _totalCount) return;
    _loadingMore = true;
    await _fetch(reset: false);
    _loadingMore = false;
  }

  Future<void> _fetch({required bool reset}) async {
    final result = await SearchDirectoryUsecase(_repository).call(
      params: SearchDirectoryParam(
        text: _text,
        departmentId: _departmentId,
        floorId: _floorId,
        type: _type,
        skipCount: reset ? 0 : _items.length,
        maxResultCount: _pageSize,
      ),
    );

    if (result.hasDataOnly) {
      _totalCount = result.data!.totalCount;
      _items.addAll(result.data!.items);
      emit(
        DirectoryLoaded(
          items: List.unmodifiable(_items),
          totalCount: _totalCount,
          hasMore: _items.length < _totalCount,
        ),
      );
    } else {
      emit(DirectoryError(result.error ?? 'err_unexpected'));
    }
  }

  /// Department suggestions for the filter. Empty on failure.
  Future<List<DepartmentItemModel>> searchDepartments(String term) async {
    final result = await DepartmentAutocompleteUsecase(
      _repository,
    ).call(params: DepartmentAutocompleteParam(term: term));
    return result.hasDataOnly ? result.data! : <DepartmentItemModel>[];
  }
}

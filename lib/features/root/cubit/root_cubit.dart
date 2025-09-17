import 'package:bloc/bloc.dart';

part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  int rootIndex = 0;

  RootCubit() : super(RootInitial());

  void changePageIndex(int pageIndex) {
    if (rootIndex != pageIndex) {
      rootIndex = pageIndex;
      emit(ChangeIndexState(rootIndex));
    }
  }
}

part of 'directory_cubit.dart';

@immutable
sealed class DirectoryState {}

final class DirectoryInitial extends DirectoryState {}

final class DirectoryLoading extends DirectoryState {}

final class DirectoryLoaded extends DirectoryState {
  final List<DirectoryItemModel> items;
  final int totalCount;
  final bool hasMore;
  DirectoryLoaded({
    required this.items,
    required this.totalCount,
    required this.hasMore,
  });
}

final class DirectoryError extends DirectoryState {
  final String message;
  DirectoryError(this.message);
}

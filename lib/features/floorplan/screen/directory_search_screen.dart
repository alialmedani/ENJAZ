import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/floorplan/cubit/directory_cubit.dart';
import 'package:enjaz/features/floorplan/data/model/directory_item_model.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/screen/floor_plan_screen.dart';
import 'package:enjaz/features/floorplan/widget/presence_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Slice 2 directory search: a search field with type/department filters and a
/// paginated result list. Tapping a result that has a floorId opens the floor
/// plan (and highlights the desk when available).
class DirectorySearchScreen extends StatelessWidget {
  /// Optional floor to scope the search to (passed as FloorId filter).
  final String? floorId;

  const DirectorySearchScreen({super.key, this.floorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DirectoryCubit()..search(floorId: floorId),
      child: _DirectoryBody(floorId: floorId),
    );
  }
}

class _DirectoryBody extends StatefulWidget {
  final String? floorId;
  const _DirectoryBody({this.floorId});

  @override
  State<_DirectoryBody> createState() => _DirectoryBodyState();
}

class _DirectoryBodyState extends State<_DirectoryBody> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  // Active filters.
  int? _type; // null = all types.
  DepartmentItemModel? _department;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DirectoryCubit>().loadMore();
    }
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _runSearch);
  }

  void _runSearch() {
    context.read<DirectoryCubit>().search(
          text: _searchController.text,
          departmentId: _department?.id,
          floorId: widget.floorId,
          type: _type,
        );
  }

  void _onTypeSelected(int? type) {
    setState(() => _type = type);
    _runSearch();
  }

  Future<void> _pickDepartment() async {
    final selected = await showModalBottomSheet<DepartmentItemModel?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DepartmentPicker(cubit: context.read<DirectoryCubit>()),
    );
    if (!mounted) return;
    // A non-null result with a null id means "clear".
    if (selected != null) {
      setState(() => _department = selected.id == null ? null : selected);
      _runSearch();
    }
  }

  void _openResult(DirectoryItemModel item) {
    if (!item.hasFloor) return;
    Navigation.push(
      FloorPlanScreen(floorId: item.floorId!, highlightDeskId: item.deskId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('directory_title'.tr()),
        backgroundColor: AppColors.xprimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onTextChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                hintText: 'directory_search_hint'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          _FilterBar(
            type: _type,
            department: _department,
            onTypeSelected: _onTypeSelected,
            onDepartmentTap: _pickDepartment,
            onDepartmentClear: () {
              setState(() => _department = null);
              _runSearch();
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<DirectoryCubit, DirectoryState>(
              builder: (context, state) {
                if (state is DirectoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DirectoryError) {
                  return _ErrorBody(
                    message: state.message.tr(),
                    onRetry: _runSearch,
                  );
                }
                if (state is DirectoryLoaded) {
                  if (state.items.isEmpty) {
                    return Center(child: Text('directory_no_results'.tr()));
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      if (i >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return _DirectoryTile(
                        item: state.items[i],
                        onTap: () => _openResult(state.items[i]),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final int? type;
  final DepartmentItemModel? department;
  final ValueChanged<int?> onTypeSelected;
  final VoidCallback onDepartmentTap;
  final VoidCallback onDepartmentClear;

  const _FilterBar({
    required this.type,
    required this.department,
    required this.onTypeSelected,
    required this.onDepartmentTap,
    required this.onDepartmentClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _chip('directory_filter_all'.tr(), type == null,
              () => onTypeSelected(null)),
          _chip('directory_type_person'.tr(),
              type == DirectoryItemType.person.value,
              () => onTypeSelected(DirectoryItemType.person.value)),
          _chip('directory_type_desk'.tr(),
              type == DirectoryItemType.desk.value,
              () => onTypeSelected(DirectoryItemType.desk.value)),
          _chip('directory_type_room'.tr(),
              type == DirectoryItemType.room.value,
              () => onTypeSelected(DirectoryItemType.room.value)),
          _chip('directory_type_resource'.tr(),
              type == DirectoryItemType.resource.value,
              () => onTypeSelected(DirectoryItemType.resource.value)),
          const SizedBox(width: 4),
          Center(
            child: ActionChip(
              avatar: const Icon(Icons.business, size: 16),
              label: Text(
                department?.name ?? 'directory_filter_department'.tr(),
              ),
              onPressed: onDepartmentTap,
            ),
          ),
          if (department != null)
            Center(
              child: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDepartmentClear,
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.xprimaryColor.withValues(alpha: 0.25),
      ),
    );
  }
}

class _DirectoryTile extends StatelessWidget {
  final DirectoryItemModel item;
  final VoidCallback onTap;

  const _DirectoryTile({required this.item, required this.onTap});

  IconData get _icon {
    switch (item.type) {
      case DirectoryItemType.person:
        return Icons.person_outline;
      case DirectoryItemType.desk:
        return Icons.event_seat_outlined;
      case DirectoryItemType.room:
        return Icons.meeting_room_outlined;
      case DirectoryItemType.resource:
        return Icons.devices_other_outlined;
    }
  }

  String _subtitle() {
    final parts = <String>[];
    if (item.floorName != null && item.floorName!.isNotEmpty) {
      parts.add(item.floorName!);
    }
    if (item.deskLabel != null && item.deskLabel!.isNotEmpty) {
      parts.add(item.deskLabel!);
    }
    if (item.departmentName != null && item.departmentName!.isNotEmpty) {
      parts.add(item.departmentName!);
    }
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final PresenceStatus? presence = item.presence;
    final String subtitle = _subtitle();
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.xprimaryColor.withValues(alpha: 0.12),
        child: Icon(_icon, color: AppColors.xprimaryColor),
      ),
      title: Text(item.name ?? ''),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: presence == null
          ? (item.hasFloor ? const Icon(Icons.chevron_right) : null)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PresenceDot(status: presence),
                if (item.hasFloor) const Icon(Icons.chevron_right),
              ],
            ),
      onTap: item.hasFloor ? onTap : null,
    );
  }
}

class _DepartmentPicker extends StatefulWidget {
  final DirectoryCubit cubit;
  const _DepartmentPicker({required this.cubit});

  @override
  State<_DepartmentPicker> createState() => _DepartmentPickerState();
}

class _DepartmentPickerState extends State<_DepartmentPicker> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<DepartmentItemModel> _departments = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String term) async {
    setState(() => _loading = true);
    final list = await widget.cubit.searchDepartments(term);
    if (!mounted) return;
    setState(() {
      _departments = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 420,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'directory_search_department'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: Text('directory_filter_all'.tr()),
              onTap: () => Navigator.of(context).pop(DepartmentItemModel()),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _departments.isEmpty
                      ? Center(child: Text('directory_no_results'.tr()))
                      : ListView.separated(
                          itemCount: _departments.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final d = _departments[i];
                            return ListTile(
                              leading: const Icon(Icons.business),
                              title: Text(d.name ?? ''),
                              onTap: () => Navigator.of(context).pop(d),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.red),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('common_retry'.tr()),
          ),
        ],
      ),
    );
  }
}

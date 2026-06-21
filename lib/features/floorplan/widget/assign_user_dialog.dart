import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/features/floorplan/cubit/floorplan_cubit.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/data/model/desk_user_model.dart';
import 'package:flutter/material.dart';

/// Result of the assign dialog.
class AssignResult {
  /// When true the seat should be cleared (userId == null).
  final bool clear;
  final DeskUserModel? user;
  const AssignResult({this.clear = false, this.user});
}

/// Shows a dialog to pick a user (or clear the seat) for [desk].
/// Returns null when dismissed without a choice.
Future<AssignResult?> showAssignUserDialog({
  required BuildContext context,
  required FloorplanCubit cubit,
  required DeskModel desk,
}) {
  return showDialog<AssignResult>(
    context: context,
    builder: (_) => _AssignUserDialog(cubit: cubit, desk: desk),
  );
}

class _AssignUserDialog extends StatefulWidget {
  final FloorplanCubit cubit;
  final DeskModel desk;

  const _AssignUserDialog({required this.cubit, required this.desk});

  @override
  State<_AssignUserDialog> createState() => _AssignUserDialogState();
}

class _AssignUserDialogState extends State<_AssignUserDialog> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<DeskUserModel> _users = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String term) async {
    setState(() => _loading = true);
    final users = await widget.cubit.searchUsers(term);
    if (!mounted) return;
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'floorplan_assign_title'.tr(namedArgs: {'desk': widget.desk.label ?? ''}),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'floorplan_search_user'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            if (!widget.desk.isFree)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_off_outlined,
                    color: AppColors.red),
                title: Text(
                  'floorplan_clear_seat'.tr(),
                  style: const TextStyle(color: AppColors.red),
                ),
                onTap: () =>
                    Navigator.of(context).pop(const AssignResult(clear: true)),
              ),
            SizedBox(
              height: 280,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _users.isEmpty
                  ? Center(child: Text('floorplan_no_users'.tr()))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _users.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final user = _users[i];
                        final selected = user.id == widget.desk.assignedUserId;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.orange.withValues(alpha: 0.15),
                            child: const Icon(Icons.person,
                                color: AppColors.orange),
                          ),
                          title: Text(user.displayName),
                          subtitle: user.email == null
                              ? null
                              : Text(
                                  user.email!,
                                  style: const TextStyle(fontSize: 11),
                                ),
                          trailing: selected
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.green)
                              : null,
                          onTap: () => Navigator.of(context)
                              .pop(AssignResult(user: user)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr()),
        ),
      ],
    );
  }
}

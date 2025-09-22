import 'package:enjaz/features/FO/data/usecase/get_place_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';

import 'package:enjaz/features/FO/cubit/place_cubit.dart';
import 'package:enjaz/features/FO/data/model/place_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';

class FloorDropdown extends StatefulWidget {
  const FloorDropdown({
    super.key,
    this.initialPlaceId,
    this.onChanged,
    this.decoration,
  });

  final String? initialPlaceId;
  final ValueChanged<PlaceModel?>? onChanged;
  final InputDecoration? decoration;

  @override
  State<FloorDropdown> createState() => _FloorDropdownState();
}

class _FloorDropdownState extends State<FloorDropdown> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialPlaceId;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PaginationList(
        repositoryCallBack: (data) {
          final placeCubit = context.read<PlaceCubit>();
          final req = (data is GetListRequest) ? data : GetListRequest();

          placeCubit.getPlaceParam = GetPlaceParam(
            request: req,
            type: 1,
            floorId: null,
            term: null,
          );

          return placeCubit.fetchPLaceServies(req);
        },
        listBuilder: (list) {
          final floors = list.cast<PlaceModel>();
          final hasSelected = floors.any(
            (f) => (f.id?.toString() ?? '') == _selectedId,
          );
          final value = hasSelected ? _selectedId : null;

          if (floors.isEmpty) {
            return DropdownButtonFormField<String>(
              isExpanded: true,
              value: null,
              items: const [],
              onChanged: null,
              decoration:
                  widget.decoration ??
                  _deco('floors_loading'.tr(), prefix: Icons.business_rounded),
            );
          }

          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: value, // controlled
            items: floors
                .map(
                  (f) => _menuItem<String>(
                    value: (f.id?.toString() ?? ''),
                    title: (f.name ?? '—'),
                    icon: Icons.business_rounded,
                  ),
                )
                .toList(),
            onChanged: (id) {
              setState(() => _selectedId = id);
              final model = floors.firstWhere(
                (f) => (f.id?.toString() ?? '') == id,
                orElse: () => PlaceModel(),
              );
              widget.onChanged?.call(id == null ? null : model);
            },
            decoration:
                widget.decoration ??
                _deco(
                  'floor'.tr(),
                  prefix: Icons.business_rounded,
                ), // لديك مفتاح "floor"
            iconEnabledColor: AppColors.xprimaryColor,
          );
        },
      ),
    );
  }
}

class OfficeDropdown extends StatefulWidget {
  const OfficeDropdown({
    super.key,
    required this.noFloor,
    required this.floorId,
    this.initialPlaceId,
    this.onChanged,
    this.decoration,
  });

  final bool noFloor;
  final String floorId;
  final String? initialPlaceId;
  final ValueChanged<PlaceModel?>? onChanged;
  final InputDecoration? decoration;

  @override
  State<OfficeDropdown> createState() => _OfficeDropdownState();
}

class _OfficeDropdownState extends State<OfficeDropdown> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialPlaceId;
  }

  @override
  void didUpdateWidget(covariant OfficeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floorId != widget.floorId) {
      setState(() => _selectedId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.noFloor,
      child: Opacity(
        opacity: widget.noFloor ? .55 : 1,
        child: SizedBox(
          height: 100,
          child: PaginationList(
            key: ValueKey<String>('office-${widget.floorId}'),
            repositoryCallBack: (data) {
              final placeCubit = context.read<PlaceCubit>();
              final req = (data is GetListRequest) ? data : GetListRequest();

              placeCubit.getPlaceParam = GetPlaceParam(
                request: req,
                type: 2,
                floorId: widget.floorId,
                term: null,
              );

              return placeCubit.fetchPLaceServies(req);
            },
            listBuilder: (list) {
              final offices = list.cast<PlaceModel>();
              final hasSelected = offices.any(
                (o) => (o.id?.toString() ?? '') == _selectedId,
              );
              final value = hasSelected ? _selectedId : null;

              if (offices.isEmpty) {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: null,
                  items: const [],
                  onChanged: null,
                  decoration:
                      widget.decoration ??
                      _deco(
                        widget.noFloor
                            ? 'select_floor_first'.tr()
                            : 'offices_loading'.tr(),
                        prefix: Icons.apartment_outlined,
                      ),
                );
              }

              return DropdownButtonFormField<String>(
                isExpanded: true,
                value: value, // controlled
                items: offices
                    .map(
                      (o) => _menuItem<String>(
                        value: (o.id?.toString() ?? ''),
                        title: (o.name ?? '—'),
                        icon: Icons.apartment_outlined,
                      ),
                    )
                    .toList(),
                onChanged: (id) {
                  setState(() => _selectedId = id);
                  final model = offices.firstWhere(
                    (o) => (o.id?.toString() ?? '') == id,
                    orElse: () => PlaceModel(),
                  );
                  widget.onChanged?.call(id == null ? null : model);
                },
                decoration:
                    widget.decoration ??
                    _deco(
                      'office'.tr(),
                      prefix: Icons.apartment_outlined,
                    ), // لديك مفتاح "office"
                iconEnabledColor: AppColors.xprimaryColor,
                validator: (_) {
                  if (widget.floorId.isEmpty) return null;
                  return (value == null || value.isEmpty)
                      ? 'err_select_office'.tr()
                      : null;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// ===== Utils =====

DropdownMenuItem<T> _menuItem<T>({
  required T value,
  required String title,
  IconData? icon,
}) {
  return DropdownMenuItem<T>(
    value: value,
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.xprimaryColor),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}

InputDecoration _deco(String hint, {IconData? prefix}) {
  return InputDecoration(
    hintText: hint,
    labelText: hint,
    prefixIcon: prefix == null ? null : Icon(prefix),
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/features/FO/cubit/place_cubit.dart';
import 'package:enjaz/features/FO/data/model/place_model.dart';
import 'package:enjaz/features/FO/data/usecase/get_place_usecase.dart';

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
      height: 110,
      child: PaginationList(
        repositoryCallBack: (data) {
          final placeCubit = context.read<PlaceCubit>();
          final request = (data is GetListRequest) ? data : GetListRequest();

          placeCubit.getPlaceParam = GetPlaceParam(
            request: request,
            type: 1,
            floorId: null,
            term: null,
          );

          return placeCubit.fetchPLaceServies(request);
        },
        listBuilder: (list) {
          final floors = list.cast<PlaceModel>();
          final hasSelected = floors.any(
            (floor) => (floor.id?.toString() ?? '') == _selectedId,
          );
          final value = hasSelected ? _selectedId : null;
          final label = floors.isEmpty ? 'floors_loading'.tr() : 'floor'.tr();

          return _GlassDropdownContainer(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: floors.isEmpty ? null : value,
              items: floors
                  .map(
                    (floor) => DropdownMenuItem<String>(
                      value: floor.id?.toString() ?? '',
                      child: Text(
                        (floor.name ?? '--').trim().isEmpty
                            ? '--'
                            : floor.name!.trim(),
                        style: AppTextStyle.getRegularStyle(
                          fontSize: AppFontSize.size_14,
                          color: AppColors.black23,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: floors.isEmpty
                  ? null
                  : (id) {
                      setState(() => _selectedId = id);
                      final model = floors.firstWhere(
                        (floor) => (floor.id?.toString() ?? '') == id,
                        orElse: () => PlaceModel(),
                      );
                      widget.onChanged?.call(id == null ? null : model);
                    },
              decoration: _decorate(
                widget.decoration,
                label: label,
                icon: Icons.business_rounded,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.orange,
              ),
              dropdownColor: Colors.white,
            ),
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
    final disabled = widget.noFloor || widget.floorId.isEmpty;

    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? 0.55 : 1,
        child: SizedBox(
          height: 110,
          child: PaginationList(
            key: ValueKey<String>('office-${widget.floorId}'),
            repositoryCallBack: (data) {
              final placeCubit = context.read<PlaceCubit>();
              final request = (data is GetListRequest)
                  ? data
                  : GetListRequest();

              placeCubit.getPlaceParam = GetPlaceParam(
                request: request,
                type: 2,
                floorId: widget.floorId,
                term: null,
              );

              return placeCubit.fetchPLaceServies(request);
            },
            listBuilder: (list) {
              final offices = list.cast<PlaceModel>();
              final hasSelected = offices.any(
                (office) => (office.id?.toString() ?? '') == _selectedId,
              );
              final value = hasSelected ? _selectedId : null;

              final label = widget.noFloor
                  ? 'select_floor_first'.tr()
                  : offices.isEmpty
                  ? 'offices_loading'.tr()
                  : 'office'.tr();

              return _GlassDropdownContainer(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: offices.isEmpty ? null : value,
                  items: offices
                      .map(
                        (office) => DropdownMenuItem<String>(
                          value: office.id?.toString() ?? '',
                          child: Text(
                            (office.name ?? '--').trim().isEmpty
                                ? '--'
                                : office.name!.trim(),
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_14,
                              color: AppColors.black23,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: offices.isEmpty
                      ? null
                      : (id) {
                          setState(() => _selectedId = id);
                          final model = offices.firstWhere(
                            (office) => (office.id?.toString() ?? '') == id,
                            orElse: () => PlaceModel(),
                          );
                          widget.onChanged?.call(id == null ? null : model);
                        },
                  decoration: _decorate(
                    widget.decoration,
                    label: label,
                    icon: Icons.apartment_outlined,
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.orange,
                  ),
                  dropdownColor: Colors.white,
                  validator: (_) {
                    if (widget.floorId.isEmpty) return null;
                    return (value == null || value.isEmpty)
                        ? 'err_select_office'.tr()
                        : null;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GlassDropdownContainer extends StatelessWidget {
  const _GlassDropdownContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.78),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(child: child),
        ),
      ),
    );
  }
}

InputDecoration _decorate(
  InputDecoration? base, {
  required String label,
  required IconData icon,
}) {
  final decoration = base ?? const InputDecoration();
  return decoration.copyWith(
    labelText: label,
    hintText: label,
    prefixIcon: decoration.prefixIcon ?? Icon(icon, color: AppColors.orange),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding:
        decoration.contentPadding ??
        const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
    labelStyle: AppTextStyle.getRegularStyle(
      fontSize: AppFontSize.size_13,
      color: AppColors.secondPrimery,
    ),
  );
}

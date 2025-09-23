import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/ui/dialogs/dialogs.dart';
import 'package:enjaz/core/ui/widgets/custom_button.dart';
import 'package:enjaz/core/boilerplate/create_model/widgets/create_model.dart';

import 'package:enjaz/features/order/cubit/order_cubit.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/place/data/model/place_model.dart';

import 'place_dropdowns.dart';
import 'package:enjaz/core/results/result.dart';

class CheckoutBar extends StatefulWidget {
  const CheckoutBar({
    super.key,
    required this.totalItems,
    this.onCheckoutComplete,
  });

  final int totalItems;
  final VoidCallback? onCheckoutComplete;

  @override
  State<CheckoutBar> createState() => _CheckoutBarState();
}

class _CheckoutBarState extends State<CheckoutBar>
    with TickerProviderStateMixin {
  PlaceModel? _selectedFloor;
  PlaceModel? _selectedOffice;
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.orange;
    final theme = Theme.of(context);
    final noFloor = _selectedFloor == null;
    final floorId = _selectedFloor?.id?.toString() ?? '';

    final secondaryText = _selectedFloor == null
        ? 'cart_intro'.tr()
        : [
            _selectedFloor?.name?.trim() ?? '',
            _selectedOffice?.name?.trim() ?? '',
          ].where((part) => part.isNotEmpty).join(' / ');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.92),
                  Colors.white.withValues(alpha: 0.72),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.58)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 22,
              vertical: _expanded ? 26 : 20,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _ExpandHandle(),
                  const SizedBox(height: 14),
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _toggleExpanded,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: accent.withValues(alpha: 0.16),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 22,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'checkout_total_cups_in_cart'.tr(),
                                  style: AppTextStyle.getRegularStyle(
                                    fontSize: AppFontSize.size_13,
                                    color: AppColors.black23,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  secondaryText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.getRegularStyle(
                                    fontSize: AppFontSize.size_11,
                                    color: AppColors.secondPrimery,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _TotalBadge(total: widget.totalItems, accent: accent),
                          const SizedBox(width: 12),
                          _ExpandToggleIcon(
                            expanded: _expanded,
                            accent: accent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Theme(
                      data: theme.copyWith(
                        dropdownMenuTheme: DropdownMenuThemeData(
                          textStyle: AppTextStyle.getRegularStyle(
                            fontSize: AppFontSize.size_13,
                            color: AppColors.black23,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                            elevation: MaterialStateProperty.all<double>(8),
                            shadowColor: MaterialStateProperty.all<Color>(
                              Colors.black.withValues(alpha: 0.18),
                            ),
                            surfaceTintColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                            shape:
                                MaterialStateProperty.all<
                                  RoundedRectangleBorder
                                >(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                _StepIndicator(
                                  index: 1,
                                  label: 'floor'.tr(),
                                  active: true,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                _StepIndicator(
                                  index: 2,
                                  label: 'office'.tr(),
                                  active: !noFloor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            FloorDropdown(
                              initialPlaceId: _selectedFloor?.id?.toString(),
                              onChanged: (p) {
                                setState(() {
                                  _selectedFloor = p;
                                  _selectedOffice = null;
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            OfficeDropdown(
                              noFloor: noFloor,
                              floorId: floorId,
                              initialPlaceId: _selectedOffice?.id?.toString(),
                              onChanged: (p) => setState(() {
                                _selectedOffice = p;
                              }),
                            ),
                            const SizedBox(height: 20),
                            Divider(
                              height: 24,
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                            CreateModel<OrderModel>(
                              withValidation: false,
                              onSuccess: (_) {
                                if (!mounted) return;
                                Dialogs.showSnackBar(
                                  message: 'checkout_success'.tr(),
                                );
                                setState(() => _expanded = false);
                                widget.onCheckoutComplete?.call();
                              },
                              useCaseCallBack: (_) {
                                final fId =
                                    _selectedFloor?.id?.toString() ?? '';
                                final oId =
                                    _selectedOffice?.id?.toString() ?? '';

                                if (fId.isEmpty) {
                                  Dialogs.showSnackBar(
                                    message: 'err_select_floor'.tr(),
                                  );
                                  return _fail<OrderModel>('floor required');
                                }
                                if (oId.isEmpty) {
                                  Dialogs.showSnackBar(
                                    message: 'err_select_office'.tr(),
                                  );
                                  return _fail<OrderModel>('office required');
                                }

                                final cubit = context.read<OrderCubit>();
                                cubit.setDeliveryPlace(
                                  floorId: fId,
                                  officeId: oId,
                                );
                                return cubit.requestOrder();
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  color: accent,
                                  text: 'checkout_proceed'.tr(),
                                  textStyle: AppTextStyle.getBoldStyle(
                                    fontSize: AppFontSize.size_16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    crossFadeState: _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 260),
                    sizeCurve: Curves.easeOutCubic,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalBadge extends StatelessWidget {
  const _TotalBadge({required this.total, required this.accent});

  final int total;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [accent, accent.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        '$total',
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ExpandToggleIcon extends StatelessWidget {
  const _ExpandToggleIcon({required this.expanded, required this.accent});

  final bool expanded;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.14),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.expand_less_rounded, color: accent),
      ),
    );
  }
}

class _ExpandHandle extends StatelessWidget {
  const _ExpandHandle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 48,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.index,
    required this.label,
    required this.active,
  });

  final int index;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.orange;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: active
                ? LinearGradient(
                    colors: [accent, accent.withValues(alpha: 0.7)],
                  )
                : null,
            color: active ? null : Colors.white.withValues(alpha: 0.65),
            border: Border.all(
              color: active
                  ? accent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_13,
              color: active ? Colors.white : AppColors.black23,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyle.getRegularStyle(
            fontSize: AppFontSize.size_11,
            color: active ? AppColors.black23 : AppColors.secondPrimery,
          ),
        ),
      ],
    );
  }
}

// Helper to return failed result
Future<Result<T>> _fail<T>(String message) async {
  return Result<T>(error: message);
}

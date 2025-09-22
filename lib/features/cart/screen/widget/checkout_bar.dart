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
import 'package:enjaz/features/FO/data/model/place_model.dart';

import 'place_dropdowns.dart';
import 'empty_cart_view.dart';
import 'package:enjaz/core/results/result.dart';

class CheckoutBar extends StatefulWidget {
  const CheckoutBar({super.key, required this.totalItems});

  final int totalItems;

  @override
  State<CheckoutBar> createState() => _CheckoutBarState();
}

class _CheckoutBarState extends State<CheckoutBar> {
  PlaceModel? _selectedFloor;
  PlaceModel? _selectedOffice;

  @override
  Widget build(BuildContext context) {
    final noFloor = _selectedFloor == null;
    final floorId = _selectedFloor?.id?.toString() ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 20,
                    color: AppColors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'checkout_total_cups_in_cart'.tr(),
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_13,
                        color: AppColors.black23,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.totalItems}',
                    style: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_18,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              FloorDropdown(
                initialPlaceId: _selectedFloor?.id?.toString(),
                onChanged: (p) => setState(() {
                  _selectedFloor = p;
                  _selectedOffice = null;
                }),
              ),
              const SizedBox(height: 10),

              OfficeDropdown(
                noFloor: noFloor,
                floorId: floorId,
                initialPlaceId: _selectedOffice?.id?.toString(),
                onChanged: (p) => setState(() => _selectedOffice = p),
              ),

              const SizedBox(height: 12),
              CreateModel<OrderModel>(
                withValidation: false,
                onSuccess: (_) {
                  Dialogs.showSnackBar(message: 'checkout_success'.tr());
                  // تفريغ السلة من الشاشة الأم
                },
                useCaseCallBack: (_) {
                  final fId = _selectedFloor?.id?.toString() ?? '';
                  final oId = _selectedOffice?.id?.toString() ?? '';

                  if (fId.isEmpty) {
                    Dialogs.showSnackBar(message: 'err_select_floor'.tr());
                    return _fail<OrderModel>('floor required');
                  }
                  if (oId.isEmpty) {
                    Dialogs.showSnackBar(message: 'err_select_office'.tr());
                    return _fail<OrderModel>('office required');
                  }

                  final cubit = context.read<OrderCubit>();
                  // لازم تكون موجودة داخل OrderCubit
                  cubit.setDeliveryPlace(floorId: fId, officeId: oId);
                  return cubit.requestOrder();
                },
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    color: AppColors.orange,
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
    );
  }
}

// بدل الـ helper القديم
Future<Result<T>> _fail<T>(String message) async {
  return Result<T>(error: message); // أو RemoteResult<T>(error: message)
}

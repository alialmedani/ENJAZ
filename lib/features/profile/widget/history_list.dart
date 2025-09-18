import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'fade_slide_in.dart';

class HistoryList extends StatelessWidget {
  final OrderModel orderModel;
  const HistoryList({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Container(
        padding: const EdgeInsets.all(AppPaddingSize.padding_16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.darkAccentColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_cafe, color: AppColors.darkAccentColor),
            ),
            const SizedBox(width: AppPaddingSize.padding_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${orderModel.orderItems?.length ?? 0} ${'items'.tr()}",
                          style: AppTextStyle.getBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color: AppColors.black23,
                          ),
                        ),
                      ),
                      Text(
                        orderModel.creationTime ?? "",
                        style: AppTextStyle.getRegularStyle(
                          fontSize: AppFontSize.size_12,
                          color: AppColors.secondPrimery,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'quantity'.tr(
                      namedArgs: {'q': '${orderModel.orderItems?.length ?? 0}'},
                    ),
                    style: AppTextStyle.getRegularStyle(
                      fontSize: AppFontSize.size_12,
                      color: AppColors.black23,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('reorder_todo'.tr())),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text('reorder'.tr()),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('more_soon'.tr())),
                            ),
                        icon: const Icon(Icons.more_horiz),
                        label: Text('more'.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

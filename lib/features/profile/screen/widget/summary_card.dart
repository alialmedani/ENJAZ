import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

class SummaryCard extends StatelessWidget {
  final String monthLabel;
  final int count;
  final double total;
  final String topDrink;

  const SummaryCard({
    super.key,
    required this.monthLabel,
    required this.count,
    required this.total,
    required this.topDrink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'summary_of'.tr(namedArgs: {'month': monthLabel}),
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color: AppColors.black23,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('share_soon'.tr())));
                },
                icon: const Icon(Icons.share),
                label: Text('share'.tr()),
              ),
            ],
          ),
          const SizedBox(height: AppPaddingSize.padding_12),
          Row(
            children: [
              _StatTile(title: 'orders'.tr(), value: '$count'),
              _StatTile(
                title: 'total'.tr(),
                value: 'currency_amount'.tr(
                  namedArgs: {'amount': total.toStringAsFixed(2)},
                ),
              ),
              _StatTile(title: 'top_drink'.tr(), value: topDrink),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: AppPaddingSize.padding_8),
        padding: const EdgeInsets.all(AppPaddingSize.padding_12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
          border: Border.all(color: AppColors.greyE5),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_12,
                color: AppColors.secondPrimery,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

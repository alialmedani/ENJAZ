import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryFilters extends StatefulWidget {
  final DateTime? selectedPrevMonth;
  final ValueChanged<DateTime?> onSelectPrevMonth;

  // اختياري: 0 => this_month, 1 => previous_months
  final ValueChanged<int>? onTabChanged;

  const HistoryFilters({
    super.key,
    required this.selectedPrevMonth,
    required this.onSelectPrevMonth,
    this.onTabChanged,
  });

  @override
  State<HistoryFilters> createState() => _HistoryFiltersState();
}

class _HistoryFiltersState extends State<HistoryFilters>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabs.indexIsChanging) return;
        widget.onTabChanged?.call(_tabs.index);
        setState(() {}); // لإعادة الطلاء عند تغيّر المؤشر
      });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HistorySegmented(controller: _tabs),
        const SizedBox(height: AppPaddingSize.padding_12),

        // عند اختيار "الأشهر السابقة" نظهر اختيار الشهر
        if (_tabs.index == 1)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final first = DateTime(now.year, now.month - 5);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: first,
                      lastDate: now,
                      helpText: 'pick_any_day_of_month'.tr(),
                    );
                    if (picked != null) {
                      widget.onSelectPrevMonth(
                        DateTime(picked.year, picked.month),
                      );
                    }
                  },
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    widget.selectedPrevMonth == null
                        ? 'pick_month'.tr()
                        : DateFormat(
                            'yyyy-MM',
                          ).format(widget.selectedPrevMonth!),
                  ),
                ),
              ),
              const SizedBox(width: AppPaddingSize.padding_8),
              if (widget.selectedPrevMonth != null)
                IconButton(
                  onPressed: () => widget.onSelectPrevMonth(null),
                  icon: const Icon(Icons.clear),
                ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

// ================= Customized wide segmented like Overview/History =================
 
/// ========================
/// CONFIG — غيّر القيم هنا
/// ========================
class _HistorySegConfig {
  // أبعاد
  final double height;
  final double outerRadius;
  final double innerRadius;
  final double padding; // نفس الهامش الداخلي حول الـ pill

  // نصوص
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final double unselectedTextOpacity;

  // تدرّج this_month
  final Color thisMonthGradientStart;
  final Color thisMonthGradientEnd;

  // تدرّج previous_months
  final Color previousMonthGradientStart;
  final Color previousMonthGradientEnd;

  const _HistorySegConfig({
    this.height = 50,
    this.outerRadius = 14,
    this.innerRadius = 10,
    this.padding = 22,

    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.white,
    this.unselectedTextOpacity = .72,

    // افتراضياً نستخدم ألوان مشروعك
    this.thisMonthGradientStart = const Color(0xFF4A90E2), // أو AppColors.darkAccentColor
    this.thisMonthGradientEnd   = const Color(0xFFF5A623), // أو AppColors.xorangeColor

    this.previousMonthGradientStart = const Color(0xFF4A90E2),
    this.previousMonthGradientEnd   = const Color(0xFFF5A623),
  });
}

/// استدعِها هكذا: _HistorySegmented(controller: _tabs, config: const _HistorySegConfig(...))
class _HistorySegmented extends StatelessWidget {
  final TabController controller;
  final _HistorySegConfig config;

  const _HistorySegmented({
    super.key,
    required this.controller,
    this.config = const _HistorySegConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['this_month'.tr(), 'previous_months'.tr()];
    final anim = controller.animation ?? controller;

    return Container(
      height: config.height,
      decoration: BoxDecoration(
        color: AppColors.xbackgroundColor,
        borderRadius: BorderRadius.circular(config.outerRadius),
        border: Border.all(color: const Color(0xFFEFE4DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(config.padding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.innerRadius),
        child: Stack(
          children: [
            // خلفية التركيز تمتد على كامل العرض
            Positioned.fill(
              child: AnimatedBuilder(
                animation: anim,
                builder: (_, __) {
                  final grad = _currentGradient(controller.index, config);
                  return Container(
                    decoration: BoxDecoration(
                      gradient: grad,
                    ),
                  );
                },
              ),
            ),

            // عناوين التبويبات
            Row(
              children: List.generate(tabs.length, (i) {
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.animateTo(
                      i,
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                    ),
                    child: AnimatedBuilder(
                      animation: anim,
                      builder: (_, __) {
                        final bool selected = controller.index == i;
                        final Color baseColor = selected
                            ? config.selectedTextColor
                            : config.unselectedTextColor.withOpacity(config.unselectedTextOpacity);
                        final FontWeight fw = selected ? FontWeight.w800 : FontWeight.w600;

                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 140),
                            style: TextStyle(
                              color: baseColor,
                              fontSize: 14,
                              fontWeight: fw,
                            ),
                            child: Text(tabs[i]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// هنا تحدّد أي تدرّج تريد لكل تبويب
  LinearGradient _currentGradient(int index, _HistorySegConfig c) {
    if (index == 0) {
      // this_month
      return LinearGradient(
        colors: [c.thisMonthGradientStart, c.thisMonthGradientEnd],
      );
    } else {
      // previous_months
      return LinearGradient(
        colors: [c.previousMonthGradientStart, c.previousMonthGradientEnd],
      );
    }
  }
}

// lib/features/profile/screens/profile_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/profile/data/model/order_history_entry.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
import 'package:enjaz/features/profile/data/repo/profile_repository.dart';
import 'package:enjaz/features/profile/data/usecase/get_order_history_usecase.dart';
import 'package:enjaz/features/profile/data/usecase/get_profile_usecase.dart';
import 'package:enjaz/features/profile/screen/widget/favorites_row.dart';
import 'package:enjaz/features/profile/screen/widget/header_card.dart';
import 'package:enjaz/features/profile/screen/widget/history_filters.dart';
import 'package:enjaz/features/profile/screen/widget/history_list.dart';
import 'package:enjaz/features/profile/screen/widget/logout_card.dart';
import 'package:enjaz/features/profile/screen/widget/profile_arc_header.dart';
import 'package:enjaz/features/profile/screen/widget/settings_card.dart';
import 'package:enjaz/features/profile/screen/widget/skeletons.dart';
import 'package:enjaz/features/profile/screen/widget/summary_card.dart';
import 'package:enjaz/features/staff/cubit/ccubit1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';

 
 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _repo = ProfileRepository();

  // لو اخترت شهر سابق من الفلتر
  final ValueNotifier<DateTime?> _selectedPrevMonthVN = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _selectedPrevMonthVN.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildSummary(List<OrderHistoryEntry> list) {
    final count = list.length;
    double total = 0;
    final Map<String, int> byDrink = {};
    for (final e in list) {
      total += e.totalPrice;
      // لو عندك اسم المشروب داخل e.orderName أو مشابه، عدّل المفتاح:
      // final drinkKey = (e.order.itemName).toString();
      // byDrink[drinkKey] = (byDrink[drinkKey] ?? 0) + 1;
    }
    String topDrink = '-';
    if (byDrink.isNotEmpty) {
      topDrink =
          (byDrink.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
              .first
              .key;
    }
    return {'count': count, 'total': total, 'topDrink': topDrink};
  }

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('yyyy-MM');
    final thisMonth = DateTime(DateTime.now().year, DateTime.now().month);

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ProfileCubit())],
      child: Scaffold(
        backgroundColor: AppColors.xbackgroundColor3,
        body: Column(
          children: [
            ProfileArcHeader(controller: _tab, title: 'profile_title'.tr()),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  // ===== Overview =====
                  Padding(
                    padding: const EdgeInsets.all(AppPaddingSize.padding_16),
                    child: GetModel<UserProfile>(
                      useCaseCallBack: () => GetProfileUsecase(_repo).call(),
                      modelBuilder: (profile) {
                        context.read<ProfileCubit>().setProfile(profile);
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: 22),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 80),
                              child: HeaderCard(profile: profile),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 160),
                              child: SettingsCard(profile: profile),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 240),
                              child: FavoritesRow(profile: profile),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 320),
                              child: const LogoutCard(),
                            ),
                          ],
                        );
                      },
                      loading: const ProfileSkeleton(),
                    ),
                  ),

                  // ===== History =====
                  Padding(
                    padding: const EdgeInsets.all(AppPaddingSize.padding_16),
                    child: ValueListenableBuilder<DateTime?>(
                      valueListenable: _selectedPrevMonthVN,
                      builder: (_, selectedPrevMonth, __) {
                        final chosenMonth = selectedPrevMonth ?? thisMonth;
                        return Column(
                          children: [
                            const SizedBox(height: 22),
                            FadeSlideIn(
                              delay: const Duration(milliseconds: 60),
                              child: HistoryFilters(
                                selectedPrevMonth: selectedPrevMonth,
                                onSelectPrevMonth: (d) =>
                                    _selectedPrevMonthVN.value = d,
                              ),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),
                            Expanded(
                              child: GetModel<List<OrderHistoryEntry>>(
                                useCaseCallBack: () => GetOrderHistoryUsecase(
                                  _repo,
                                ).call(month: chosenMonth),
                                modelBuilder: (list) {
                                  final summary = _buildSummary(list);
                                  return Column(
                                    children: [
                                      FadeSlideIn(
                                        delay: const Duration(milliseconds: 80),
                                        child: SummaryCard(
                                          monthLabel: monthFormat.format(
                                            chosenMonth,
                                          ),
                                          count: summary['count'] as int,
                                          total: summary['total'] as double,
                                          topDrink:
                                              summary['topDrink'] as String,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppPaddingSize.padding_12,
                                      ),
                                      Expanded(
                                        child: HistoryList(entries: list),
                                      ),
                                    ],
                                  );
                                },
                                loading: const HistorySkeleton(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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

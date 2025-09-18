import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';
import 'package:enjaz/features/profile/widget/header_card.dart';
import 'package:enjaz/features/profile/widget/history_list.dart';
import 'package:enjaz/features/profile/widget/logout_card.dart';
import 'package:enjaz/features/profile/widget/profile_arc_header.dart';
import 'package:enjaz/features/profile/widget/settings_card.dart';
import 'package:enjaz/features/profile/widget/skeletons.dart';
import 'package:enjaz/features/staff/cubit/ccubit1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import '../../order/cubit/order_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: GetModel<UserModel>(
                    useCaseCallBack: () {
                      return context
                          .read<ProfileCubit>()
                          .fetchCurrentCustomer();
                    },
                    modelBuilder: (profile) {
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
                            child: SettingsCard(userModel: profile),
                          ),
                          const SizedBox(height: AppPaddingSize.padding_16),
                          // FadeSlideIn(
                          //   delay: const Duration(milliseconds: 240),
                          //   child: FavoritesRow(profile: profile),
                          // ),
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
                  child: SizedBox(
                    height: 300,
                    child: PaginationList<OrderModel>(
                      repositoryCallBack: (data) {
                        return context.read<OrderCubit>().fetchAllOrder(data);
                      },
                      listBuilder: (list) {
                        return Column(
                          children: [
                            const SizedBox(height: AppPaddingSize.padding_12),
                            Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: list.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: AppPaddingSize.padding_12,
                                ),
                                itemBuilder: (_, i) {
                                  return HistoryList(orderModel: list[i]);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      loadingWidget: const HistorySkeleton(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

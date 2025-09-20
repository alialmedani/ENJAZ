import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/features/profile/widget/sign_outaction_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/features/order/cubit/order_cubit.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';
import 'package:enjaz/features/profile/widget/history_list.dart';
import 'package:enjaz/features/profile/widget/skeletons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.xbackgroundColor3, Colors.white],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: GetModel<UserModel>(
            useCaseCallBack: () =>
                context.read<ProfileCubit>().fetchCurrentCustomer(),
            loading: const ProfileSkeleton(),
            modelBuilder: (profile) => Column(
              children: [
                _ProfileHero(profile: profile),
                Expanded(
                  child: _ProfileTabsShell(controller: _tabs, profile: profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final accent = AppColors.orange;
    final name = _displayName(profile);
    final subtitle = profile.roles?.isNotEmpty == true
        ? profile.roles!.join(' - ')
        : profile.userName ?? '';

    return SizedBox(
      height: safeTop + 230,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accent.withOpacity(0.32),
                    AppColors.xbackgroundColor3,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: safeTop + 18,
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white.withOpacity(0.78),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AvatarBadge(text: name.isNotEmpty ? name[0] : '?'),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: AppTextStyle.getBoldStyle(
                                    fontSize: AppFontSize.size_20,
                                    color: AppColors.black23,
                                  ),
                                ),
                                if (subtitle.trim().isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    style: AppTextStyle.getRegularStyle(
                                      fontSize: AppFontSize.size_12,
                                      color: AppColors.secondPrimery,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 14,
                        runSpacing: 12,
                        children: [
                          _MetricChip(
                            icon: Icons.layers_outlined,
                            label: 'Floor',
                            value: profile.floor?.toString() ?? '—',
                          ),
                          _MetricChip(
                            icon: Icons.apartment_outlined,
                            label: 'Office',
                            value: profile.office?.trim().isNotEmpty == true
                                ? profile.office!.trim()
                                : '—',
                          ),
                          if (profile.creationTime != null)
                            _MetricChip(
                              icon: Icons.calendar_today_outlined,
                              label: 'Member since',
                              value: DateFormat('d MMM yyyy').format(
                                DateTime.tryParse(profile.creationTime!) ??
                                    DateTime.now(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTabsShell extends StatelessWidget {
  const _ProfileTabsShell({required this.controller, required this.profile});

  final TabController controller;
  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _ProfileTabBar(controller: controller),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: [
                    _OverviewTab(profile: profile),
                    _HistoryTab(profile: profile),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTabBar extends StatelessWidget {
  const _ProfileTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.xbackgroundColor3,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.secondPrimery,
        labelStyle: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_13,
          color: Colors.white,
        ),
        unselectedLabelStyle: AppTextStyle.getRegularStyle(
          fontSize: AppFontSize.size_12,
          color: AppColors.secondPrimery,
        ),
        tabs: [
          Tab(text: 'tab_overview'.tr()),
          Tab(text: 'tab_history'.tr()),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final phone = profile.phoneNumber?.trim();
    final email = profile.email?.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            icon: Icons.mail_outline,
            title: 'Email',
            value: email?.isNotEmpty == true ? email! : 'Not provided',
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: phone?.isNotEmpty == true ? phone! : 'Not provided',
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.person_outline,
            title: 'Username',
            value: profile.userName ?? '—',
          ),
          const SizedBox(height: 24),
          Text(
            'Quick actions',
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: phone?.isNotEmpty == true ? () {} : null,
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.orange,
                    side: BorderSide(color: AppColors.orange.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: phone?.isNotEmpty == true ? () {} : null,
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    disabledForegroundColor: AppColors.secondPrimery
                        .withOpacity(0.4),
                    disabledBackgroundColor: AppColors.secondPrimery
                        .withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const SignOutActionButton(),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: PaginationList<OrderModel>(
        repositoryCallBack: (data) =>
            context.read<OrderCubit>().fetchAllOrder(data),
        loadingWidget: const HistorySkeleton(),
        listBuilder: (orders) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppPaddingSize.padding_12),
            itemBuilder: (_, index) {
              final order = orders[index];
              return HistoryList(
                orderModel: order,
                profile: order.customerUser ?? profile,
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.xbackgroundColor3,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.orange),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.secondPrimery,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: AppColors.black23,
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

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.orange),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_13,
                  color: AppColors.black23,
                ),
              ),
              Text(
                label,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_10,
                  color: AppColors.secondPrimery,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_24,
          color: Colors.white,
        ),
      ),
    );
  }
}

String _displayName(UserModel profile) {
  final name = profile.name?.trim();
  if (name != null && name.isNotEmpty) return name;
  final surname = profile.surname?.trim();
  if (surname != null && surname.isNotEmpty) return surname;
  return profile.userName?.trim() ?? 'Guest';
}

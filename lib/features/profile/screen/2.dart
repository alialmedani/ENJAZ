import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/features/profile/widget/sign_outaction_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

extension UserModelDisplay on UserModel {
  String get displayName {
    final first = (name ?? '').trim();
    final last = (surname ?? '').trim();
    if (first.isEmpty && last.isEmpty) return (userName ?? '').trim();
    return [first, last].where((value) => value.isNotEmpty).join(' ');
  }

  String get displayFloor {
    final byName = (floorName ?? '').trim();
    if (byName.isNotEmpty) return byName;
    final byId = (floorId ?? '').trim();
    return byId.isNotEmpty ? byId : '--';
  }

  String get displayOffice {
    final byName = (officeName ?? '').trim();
    if (byName.isNotEmpty) return byName;
    final byId = (officeId ?? '').trim();
    return byId.isNotEmpty ? byId : '--';
  }

  String get initials {
    final first = (name ?? '').trim();
    final last = (surname ?? '').trim();
    final user = (userName ?? '').trim();
    if (first.isNotEmpty || last.isNotEmpty) {
      final n = first.isNotEmpty ? first[0] : '';
      final s = last.isNotEmpty ? last[0] : '';
      final both = (n + s).toUpperCase();
      return both.isNotEmpty ? both : '?';
    }
    return user.isNotEmpty ? user[0].toUpperCase() : '?';
  }

  String get subtitle {
    final items = (roles ?? const [])
        .map((role) => role.trim())
        .where((role) => role.isNotEmpty)
        .toList();
    if (items.isNotEmpty) return items.join(' / ');
    final user = (userName ?? '').trim();
    return user.isNotEmpty ? user : '--';
  }

  String get memberSinceText {
    final dynamic raw = creationTime;
    DateTime? parsed;

    if (raw is DateTime) {
      parsed = raw;
    } else if (raw is String) {
      final value = raw.trim();
      if (value.isNotEmpty) {
        parsed = DateTime.tryParse(value);
        if (parsed == null) {
          final numeric =
              int.tryParse(value) ?? double.tryParse(value)?.toInt();
          if (numeric != null) {
            parsed = DateTime.fromMillisecondsSinceEpoch(numeric);
          }
        }
      }
    } else if (raw is int) {
      parsed = DateTime.fromMillisecondsSinceEpoch(raw);
    } else if (raw is num) {
      parsed = DateTime.fromMillisecondsSinceEpoch(raw.toInt());
    }

    if (parsed == null) return '';
    return DateFormat('d MMM yyyy').format(parsed);
  }
}

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
      body: DecoratedBox(
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

class _ProfileGlassSurface extends StatelessWidget {
  const _ProfileGlassSurface({
    required this.borderRadius,
    required this.child,
    this.padding,
    this.margin,
    this.blurSigma = 18,
    this.backgroundOpacity = 0.94,
    this.borderOpacity = 0.6,
    this.shadows,
  });

  final BorderRadius borderRadius;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final double backgroundOpacity;
  final double borderOpacity;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    Widget surface = Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow:
            shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(backgroundOpacity),
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (margin != null) {
      surface = Padding(padding: margin!, child: surface);
    }

    return surface;
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;

    final displayName = profile.displayName;
    final initials = profile.initials;
    final subtitle = profile.subtitle;
    final floorText = profile.displayFloor;
    final officeText = profile.displayOffice;
    final memberSince = profile.memberSinceText;

    return SizedBox(
      height: safeTop + 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.xorangeColor.withOpacity(0.25),
                    AppColors.xbackgroundColor3,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: safeTop - 40,
            left: -60,
            child: const _BlurredAccentCircle(
              diameter: 240,
              colors: [Colors.white24, Colors.transparent],
            ),
          ),
          Positioned(
            top: safeTop - 20,
            right: -30,
            child: _BlurredAccentCircle(
              diameter: 200,
              colors: [
                AppColors.darkAccentColor.withOpacity(0.18),
                AppColors.xorangeColor.withOpacity(0.06),
              ],
            ),
          ),
          Positioned(
            top: safeTop + 90,
            left: 24,
            right: 24,
            child: _ProfileGlassSurface(
              borderRadius: BorderRadius.circular(40),
              padding: const EdgeInsets.fromLTRB(28, 72, 28, 28),
              child: Column(
                children: [
                  Text(
                    displayName.isEmpty ? '--' : displayName,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_20,
                      color: AppColors.black23,
                    ),
                  ),
                  if (subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                  ],
                  if (memberSince.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _MemberSincePill(date: memberSince),
                  ],
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _MetricChip(
                        icon: Icons.layers_outlined,
                        label: 'floor'.tr(),
                        value: floorText,
                      ),
                      _MetricChip(
                        icon: Icons.apartment_outlined,
                        label: 'office'.tr(),
                        value: officeText,
                      ),
                      if (profile.email?.trim().isNotEmpty ?? false)
                        _MetricChip(
                          icon: Icons.mail_outline,
                          label: 'profile_email'.tr(),
                          value: profile.email!.trim(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: safeTop + 12,
            left: 0,
            right: 0,
            child: Center(child: _AvatarBadge(text: initials)),
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
    return _ProfileGlassSurface(
      borderRadius: BorderRadius.circular(40),
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _ProfileTabBar(controller: controller),
          const SizedBox(height: 16),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
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
    final email = (profile.email ?? '').trim();
    final phone = (profile.phoneNumber ?? '').trim();
    final username = (profile.userName ?? '').trim();

    final infoCards = <Widget>[
      _InfoCard(
        icon: Icons.mail_outline,
        title: 'profile_email'.tr(),
        value: email.isNotEmpty ? email : 'profile_not_provided'.tr(),
      ),
      _InfoCard(
        icon: Icons.phone_outlined,
        title: 'profile_phone'.tr(),
        value: phone.isNotEmpty ? phone : 'profile_not_provided'.tr(),
      ),
      _InfoCard(
        icon: Icons.person_outline,
        title: 'profile_username'.tr(),
        value: username.isNotEmpty ? username : '--',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final spacing = 18.0;
        final itemWidth = isWide
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: infoCards
                    .map((card) => SizedBox(width: itemWidth, child: card))
                    .toList(),
              ),

              const SizedBox(height: 28),
              const SignOutActionButton(),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.greyE5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: PaginationList<OrderModel>(
            repositoryCallBack: (data) =>
                context.read<OrderCubit>().fetchAllOrder(data),
            loadingWidget: const HistorySkeleton(),
            listBuilder: (orders) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: orders.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppPaddingSize.padding_12),
                itemBuilder: (_, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: HistoryList(
                      orderModel: order,
                      profile: order.customerUser ?? profile,
                    ),
                  );
                },
              );
            },
          ),
        ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.xbackgroundColor3.withOpacity(0.5)],
        ),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
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
                  const SizedBox(height: 6),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.orange),
            const SizedBox(width: 10),
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
                const SizedBox(height: 2),
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
      width: 118,
      height: 118,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkAccentColor.withOpacity(0.35),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 108,
          height: 108,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.xorangeColor, AppColors.darkAccentColor],
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
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberSincePill extends StatelessWidget {
  const _MemberSincePill({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppColors.darkAccentColor.withOpacity(0.9),
            AppColors.xorangeColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkAccentColor.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            '${'profile_member_since'.tr()} $date',
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurredAccentCircle extends StatelessWidget {
  const _BlurredAccentCircle({required this.diameter, required this.colors});

  final double diameter;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors),
        ),
      ),
    );
  }
}

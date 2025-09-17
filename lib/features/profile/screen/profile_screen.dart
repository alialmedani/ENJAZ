// lib/features/profile/profile_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/core/constant/end_points/cashe_helper_constant.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';
import 'package:enjaz/features/profile/data/repo/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
import 'package:enjaz/features/profile/data/model/order_history_entry.dart';
import 'package:enjaz/features/profile/data/usecase/get_profile_usecase.dart';
import 'package:enjaz/features/profile/data/usecase/get_order_history_usecase.dart';

import 'package:enjaz/features/order/cubit/corder_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  DateTime? _selectedPrevMonth;
  final _repo = ProfileRepository();

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

  Map<String, dynamic> _buildSummary(List<OrderHistoryEntry> list) {
    final count = list.length;
    double total = 0;
    final Map<String, int> byDrink = {};
    for (final e in list) {
      total += e.totalPrice;
      final k = e.order.itemName;
     }
    String topDrink = '-';
    if (byDrink.isNotEmpty) {
      final sorted = byDrink.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topDrink = sorted.first.key;
    }
    return {'count': count, 'total': total, 'topDrink': topDrink};
  }

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('yyyy-MM');

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => OrderCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.xbackgroundColor2,
        body: Column(
          children: [
            _ProfileArcHeader(controller: _tab, title: 'profile_title'.tr()),
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
                            _FadeSlideIn(
                              delay: const Duration(milliseconds: 80),
                              child: _Header(profile: profile),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            _FadeSlideIn(
                              delay: const Duration(milliseconds: 160),
                              child: _SettingsCard(profile: profile),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            _FadeSlideIn(
                              delay: const Duration(milliseconds: 240),
                              child: _FavoritesRow(profile: profile),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            _FadeSlideIn(
                              delay: const Duration(milliseconds: 320),
                              child: const _LogoutCard(),
                            ),
                          ],
                        );
                      },
                      loading: const _ProfileSkeleton(),
                    ),
                  ),

                  // ===== History =====
                  Padding(
                    padding: const EdgeInsets.all(AppPaddingSize.padding_16),
                    child: StatefulBuilder(
                      builder: (context, setLocal) {
                        final thisMonth = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                        );
                        final chosenMonth = (_selectedPrevMonth ?? thisMonth);

                        return Column(
                          children: [
                            _FadeSlideIn(
                              delay: const Duration(milliseconds: 60),
                              child: _HistoryFilters(
                                selectedPrevMonth: _selectedPrevMonth,
                                onSelectPrevMonth: (d) {
                                  setLocal(() => _selectedPrevMonth = d);
                                },
                              ),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),
                            Expanded(
                              child: GetModel<List<OrderHistoryEntry>>(
                                useCaseCallBack: () => GetOrderHistoryUsecase(
                                  _repo,
                                ).call(month: _selectedPrevMonth ?? thisMonth),
                                modelBuilder: (list) {
                                  final summary = _buildSummary(list);
                                  return Column(
                                    children: [
                                      _FadeSlideIn(
                                        delay: const Duration(milliseconds: 80),
                                        child: _SummaryCard(
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
                                        child: _HistoryList(entries: list),
                                      ),
                                    ],
                                  );
                                },
                                loading: const _HistorySkeleton(),
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

// ========================= Header (Gradient + Segmented) =========================
class _ProfileArcHeader extends StatelessWidget {
  final TabController controller;
  final String title;

  const _ProfileArcHeader({required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 168,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _AnimatedDarkHeaderBackground(height: 132 + top),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: top + 12, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _FadeSlideIn(
                      delay: const Duration(milliseconds: 40),
                      child: Text(
                        title,
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_18,
                          color: AppColors.darkSubHeadingColor1,
                        ),
                      ),
                    ),
                  ),
                  _FadeScaleIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('settings_soon'.tr())),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: -22,
            child: _FadeSlideIn(
              delay: const Duration(milliseconds: 120),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.xbackgroundColor2,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.10),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: _SegmentedTabBar(controller: controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDarkHeaderBackground extends StatefulWidget {
  final double height;
  const _AnimatedDarkHeaderBackground({required this.height});
  @override
  State<_AnimatedDarkHeaderBackground> createState() =>
      _AnimatedDarkHeaderBackgroundState();
}

class _AnimatedDarkHeaderBackgroundState
    extends State<_AnimatedDarkHeaderBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.darkPrimaryColor,
                AppColors.darkSecondaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              _bubble(
                left: 33 + 8 * t,
                top: 38,
                size: 52 + 8 * t,
                color: AppColors.darkAccentColor.withOpacity(.20),
              ),
              _bubble(
                right: 28,
                top: 38 + 6 * (1 - t),
                size: 44,
                color: AppColors.xpurpleColor.withOpacity(.18),
              ),
              _bubble(
                left: 140,
                bottom: 22,
                size: 36 + 10 * (1 - t),
                color: AppColors.xorangeColor.withOpacity(.20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bubble({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 600),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

// ========================= Segmented TabBar =========================
class _SegmentedTabBar extends StatelessWidget {
  final TabController controller;
  const _SegmentedTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final tabs = ['tab_overview'.tr(), 'tab_history'.tr()];
    const pillRadius = 10.0;

    return LayoutBuilder(
      builder: (context, c) {
        final pillWidth = (c.maxWidth - 12) / tabs.length;
        final anim = controller.animation ?? controller;

        return Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.xbackgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFE4DE)),
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: anim,
                builder: (_, __) {
                  final v = (controller.index + controller.offset).clamp(
                    0.0,
                    (tabs.length - 1).toDouble(),
                  );
                  final left = 6 + (v * pillWidth);
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    left: left,
                    top: 6,
                    width: pillWidth,
                    height: 34,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkAccentColor,
                            AppColors.xorangeColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(pillRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkAccentColor.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: List.generate(tabs.length, (i) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        controller.animateTo(
                          i,
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: AnimatedBuilder(
                        animation: anim,
                        builder: (_, __) {
                          final dist =
                              (controller.index + controller.offset) - i;
                          final t = (1.0 - dist.abs()).clamp(0.0, 1.0);
                          final color = Color.lerp(
                            AppColors.secondPrimery,
                            Colors.white,
                            t,
                          );
                          final fw = t > .5 ? FontWeight.w800 : FontWeight.w600;
                          return Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 140),
                              style: TextStyle(
                                color: color,
                                fontSize: AppFontSize.size_14,
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
        );
      },
    );
  }
}

// ===== Fade + Slide helper / Skeletons =====
class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double dy;
  const _FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.dy = 12,
  });

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> {
  bool _show = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1 : 0,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: _show ? Offset.zero : Offset(0, widget.dy / 100),
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class _ProfileSkeleton extends StatefulWidget {
  const _ProfileSkeleton();
  @override
  State<_ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<_ProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ShimmerBox(ctrl: _ctrl, height: 88),
        const SizedBox(height: 16),
        _ShimmerBox(ctrl: _ctrl, height: 220),
        const SizedBox(height: 16),
        _ShimmerBox(ctrl: _ctrl, height: 90),
        const SizedBox(height: 16),
        _ShimmerBox(ctrl: _ctrl, height: 56),
      ],
    );
  }
}

class _HistorySkeleton extends StatefulWidget {
  const _HistorySkeleton();
  @override
  State<_HistorySkeleton> createState() => _HistorySkeletonState();
}

class _HistorySkeletonState extends State<_HistorySkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, __) => _ShimmerBox(ctrl: _ctrl, height: 120),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 6,
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final AnimationController ctrl;
  final double height;
  const _ShimmerBox({required this.ctrl, required this.height});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + ctrl.value * 2, 0),
              end: Alignment(1.0 + ctrl.value * 2, 0),
              colors: [
                Colors.white.withOpacity(.6),
                Colors.white.withOpacity(.85),
                Colors.white.withOpacity(.6),
              ],
              stops: const [0.2, 0.5, 0.8],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ========================= Header card =========================
class _Header extends StatelessWidget {
  final UserProfile profile;
  const _Header({required this.profile});

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
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
                  ),
                ),
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.xbackgroundColor,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.secondPrimery,
                        size: 28,
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(width: AppPaddingSize.padding_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black23,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'floor_office'.tr(
                    namedArgs: {
                      'floor': '${profile.defaultFloor}',
                      'office': '${profile.defaultOffice}',
                    },
                  ),
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.secondPrimery,
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

// ========================= Settings card =========================
class _SettingsCard extends StatefulWidget {
  final UserProfile profile;
  const _SettingsCard({required this.profile});

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  late AppLanguage _lang;
  late bool _notif;
  late int _floor;
  late int _office;

  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _lang = widget.profile.language;
    _notif = widget.profile.notificationsEnabled;
    _floor = widget.profile.defaultFloor;
    _office = widget.profile.defaultOffice;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final p = cubit.state ?? widget.profile;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'settings_title'.tr(),
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color: AppColors.black23,
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _saved ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.darkAccentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'saved'.tr(),
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.darkAccentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          DropdownButtonFormField<AppLanguage>(
            decoration: InputDecoration(
              labelText: 'settings_language'.tr(),
              border: const OutlineInputBorder(),
            ),
            value: _lang,
            items: [
              DropdownMenuItem(
                value: AppLanguage.ar,
                child: Text('lang_ar'.tr()),
              ),
              DropdownMenuItem(
                value: AppLanguage.en,
                child: Text('lang_en'.tr()),
              ),
            ],
            onChanged: (v) => setState(() => _lang = v ?? _lang),
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          SwitchListTile(
            title: Text('settings_notifications'.tr()),
            value: _notif,
            onChanged: (v) => setState(() => _notif = v),
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'default_floor'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  value: _floor,
                  items: List.generate(5, (i) => i + 1)
                      .map((f) => DropdownMenuItem(value: f, child: Text('$f')))
                      .toList(),
                  onChanged: (v) => setState(() => _floor = v ?? _floor),
                ),
              ),
              const SizedBox(width: AppPaddingSize.padding_12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'default_office'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  value: _office,
                  items: List.generate(6, (i) => i + 1)
                      .map((o) => DropdownMenuItem(value: o, child: Text('$o')))
                      .toList(),
                  onChanged: (v) => setState(() => _office = v ?? _office),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          // Row(
          //   children: [
          //     Expanded(
          //       child: ElevatedButton.icon(
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: AppColors.xprimaryColor,
          //         ),
          //         onPressed: () async {
          //           final next = p.copyWith(
          //             language: _lang,
          //             notificationsEnabled: _notif,
          //             defaultFloor: _floor,
          //             defaultOffice: _office,
          //           );
          //           final res = await cubit.updateSettings(next);
          //           final ok = res.hasDataOnly;
          //           if (!mounted) return;
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //               content: Text(
          //                 ok
          //                     ? 'save_success'.tr()
          //                     : (res.error ?? 'save_failed'.tr()),
          //               ),
          //               backgroundColor: ok
          //                   ? AppColors.xprimaryColor
          //                   : AppColors.secondPrimery,
          //             ),
          //           );
          //           setState(() => _saved = ok);
          //           Future.delayed(const Duration(seconds: 2), () {
          //             if (mounted) setState(() => _saved = false);
          //           });
          //         },
          //         icon: const Icon(Icons.save),
          //         label: Text('save'.tr()),
          //       ),
          //     ),
          //     const SizedBox(width: AppPaddingSize.padding_12),
          //     Expanded(
          //       child: OutlinedButton.icon(
          //         onPressed: () {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //               content: Text('export_pdf_soon'.tr()),
          //               backgroundColor: AppColors.secondPrimery,
          //             ),
          //           );
          //         },
          //         icon: const Icon(Icons.picture_as_pdf),
          //         label: Text('export_pdf'.tr()),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

// ========================= Favorites =========================
class _FavoritesRow extends StatelessWidget {
  final UserProfile profile;
  const _FavoritesRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    final orderCubit = context.read<OrderCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final buyer = profile.name;

    if (profile.favorites.isEmpty) return const SizedBox.shrink();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'favourite'.tr(),
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: AppPaddingSize.padding_12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: profile.favorites.map((name) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppPaddingSize.padding_8,
                  ),
                  child: ActionChip(
                    backgroundColor: AppColors.darkAccentColor.withOpacity(.10),
                    avatar: Icon(
                      Icons.bolt,
                      color: AppColors.darkAccentColor,
                      size: 18,
                    ),
                    label: Text(
                      name,
                      style: TextStyle(
                        color: AppColors.darkAccentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () async {
                      // final res = await profileCubit.quickReorder(
                      //   orderCubit: orderCubit,
                      //   itemName: name,
                      //   size: 'M',
                      //   buyerName: buyer,
                      //   floor: profile.defaultFloor,
                      //   office: profile.defaultOffice,
                      // );
                      // if (!context.mounted) return;
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       res.hasDataOnly
                      //           ? 'quick_order_success'.tr()
                      //           : 'quick_order_failed'.tr(),
                      //     ),
                      //     backgroundColor: res.hasDataOnly
                      //         ? AppColors.xprimaryColor
                      //         : AppColors.secondPrimery,
                      //   ),
                      // );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================= Logout =========================
class _LogoutCard extends StatelessWidget {
  const _LogoutCard();

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
      child: Row(
        children: [
          const Icon(Icons.logout),
          const SizedBox(width: AppPaddingSize.padding_12),
          Expanded(
            child: Text(
              'sign_out'.tr(),
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
            ),
          ),
             TextButton(
  onPressed: () async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('sign_out_confirm_title'.tr()),
        content: Text('sign_out_confirm_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('sign_out'.tr()),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      // امسح الرموز/الداتا (اختياري – محمي try/catch لو Hive مش مفعّل)
      try {
        await CacheHelper.box.delete(accessToken);
        await CacheHelper.box.delete(refreshToken);
        await CacheHelper.box.delete('current_user_phone');
        await CacheHelper.box.delete('current_user_role');
      } catch (_) {/* ignore if not initialized */}

      // Snack (اختياري)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('signed_out'.tr())));

      // توجيه للـ Login وإغلاق كل النّافيجاشن السابقة
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  },
  child: Text('sign_out'.tr()),
),

        ],
      ),
    );
  }
}

// ========================= History Filters =========================
class _HistoryFilters extends StatefulWidget {
  final DateTime? selectedPrevMonth;
  final ValueChanged<DateTime?> onSelectPrevMonth;

  const _HistoryFilters({
    required this.selectedPrevMonth,
    required this.onSelectPrevMonth,
  });

  @override
  State<_HistoryFilters> createState() => _HistoryFiltersState();
}

class _HistoryFiltersState extends State<_HistoryFilters>
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
          padding: const EdgeInsets.all(6),
          child: TabBar(
            controller: _tabs,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.secondPrimery,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'this_month'.tr()),
              Tab(text: 'previous_months'.tr()),
            ],
            onTap: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: AppPaddingSize.padding_12),
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

// ========================= Summary + History List =========================
class _SummaryCard extends StatelessWidget {
  final String monthLabel;
  final int count;
  final double total;
  final String topDrink;

  const _SummaryCard({
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

class _HistoryList extends StatelessWidget {
  final List<OrderHistoryEntry> entries;
  const _HistoryList({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 32),
          Center(
            child: Text(
              'no_orders_this_month'.tr(),
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.secondPrimery,
              ),
            ),
          ),
        ],
      );
    }

    final orderCubit = context.read<OrderCubit>();
    final profile = context.read<ProfileCubit>().state;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppPaddingSize.padding_12),
      itemBuilder: (_, i) {
        final e = entries[i];
        return _FadeSlideIn(
          delay: Duration(milliseconds: 60 * i),
          child: Container(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.darkAccentColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_cafe,
                    color: AppColors.darkAccentColor,
                  ),
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
                              '${e.order.itemName} • ${e.order.size}',
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_14,
                                color: AppColors.black23,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(e.createdAt),
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'quantity'.tr(namedArgs: {'q': '${e.quantity}'}),
                        style: AppTextStyle.getRegularStyle(
                          fontSize: AppFontSize.size_12,
                          color: AppColors.black23,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'total_price_currency'.tr(
                          namedArgs: {
                            'amount': e.totalPrice.toStringAsFixed(2),
                          },
                        ),
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color: AppColors.xprimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              // final res = await context
                              //     .read<ProfileCubit>()
                              //     .quickReorder(
                              //       orderCubit: orderCubit,
                              //       itemName: e.order.itemName,
                              //       size: e.order.size,
                              //       buyerName: e.order.buyerName,
                              //       floor:
                              //           profile?.defaultFloor ?? e.order.floor,
                              //       office:
                              //           profile?.defaultOffice ??
                              //           e.order.office,
                              //     );
                              // if (!context.mounted) return;
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       res.hasDataOnly
                              //           ? 'reorder_done'.tr()
                              //           : 'reorder_failed'.tr(),
                              //     ),
                              //     backgroundColor: res.hasDataOnly
                              //         ? AppColors.xprimaryColor
                              //         : AppColors.secondPrimery,
                              //   ),
                              // );
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text('reorder'.tr()),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('more_soon'.tr())),
                              );
                            },
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
      },
    );
  }
}

// ========================= Micro Interaction =========================
class _FadeScaleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _FadeScaleIconButton({required this.icon, required this.onTap});

  @override
  State<_FadeScaleIconButton> createState() => _FadeScaleIconButtonState();
}

class _FadeScaleIconButtonState extends State<_FadeScaleIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: 0.92,
        ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)),
        child: Icon(widget.icon, color: AppColors.darkSubHeadingColor1),
      ),
    );
  }
}

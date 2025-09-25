import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';
import 'package:enjaz/features/drink/cubit/drink_cubit.dart';
import 'package:enjaz/features/drink/data/model/drink_model.dart';
import 'package:enjaz/features/drink/screen/coffee_detai_screen.dart';
import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';

class CoffeeAppHomeScreen extends StatefulWidget {
  const CoffeeAppHomeScreen({super.key});

  @override
  State<CoffeeAppHomeScreen> createState() => _CoffeeAppHomeScreenState();
}

class _CoffeeAppHomeScreenState extends State<CoffeeAppHomeScreen> {
  late final PageController _promoController;
  late final List<List<Color>> _categoryGradients;
 
  double _promoPage = 0;
  int selectedIndex = 0;

  static const List<String> _intensityLabels = [
    'meta_intensity_bold',
    'meta_intensity_balanced',
    'meta_intensity_smooth',
    'meta_intensity_dark',
  ];

  List<String> get _categories => [
    'cat_all'.tr(),
    'cat_macchiato'.tr(),
    'cat_latte'.tr(),
    'cat_americano'.tr(),
    'cat_cappuccino'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _promoController = PageController(viewportFraction: 0.86);
    _promoController.addListener(_handlePromoScroll);

    _categoryGradients = [
      [AppColors.xprimaryColor, AppColors.lightOrange],
      [AppColors.xpurpleColor, AppColors.lightXPrimary],
      [AppColors.lightXOrange, AppColors.xprimaryColor],
      [AppColors.orange, AppColors.xpurpleColor],
      [AppColors.lightXPrimary, AppColors.xprimaryColor],
    ];

 
  }

  @override
  void dispose() {
    _promoController
      ..removeListener(_handlePromoScroll)
      ..dispose();
    super.dispose();
  }

  void _handlePromoScroll() {
    final page = _promoController.hasClients
        ? _promoController.page ?? _promoPage
        : _promoPage;
    if ((page - _promoPage).abs() > 0.001) {
      setState(() => _promoPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final UserModel? userModel = context.watch<ProfileCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor3,
      body: PaginationList<DrinkModel>(
        withRefresh: true,
        physics: const BouncingScrollPhysics(),
        noDataWidget: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppPaddingSize.padding_80,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_cafe_outlined,
                size: AppFontSize.size_42,
                color: AppColors.xsecondaryColor.withValues(alpha: 0.7),
              ),
              SizedBox(height: AppFontSize.size_12),
              Text(
                'home_no_coffee'.tr(),
                style: TextStyle(
                  color: AppColors.xsecondaryColor,
                  fontSize: AppFontSize.size_16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        onCubitCreated: (cubit) {
          context.read<DrinkCubit>().drinkCubit = cubit;
        },
        repositoryCallBack: (data) {
          return context.read<DrinkCubit>().fetchAllDrinkServies(data);
        },
        listBuilder: (apiList) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildAnimatedHeader(context, userModel),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddingSize.padding_22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppFontSize.size_20),
                      Text(
                        'coffee_signature_title'.tr(),
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.size_20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppFontSize.size_8),
                      Text(
                        'coffee_default_tagline'.tr(),
                        style: TextStyle(
                          color: AppColors.grey89,
                          fontSize: AppFontSize.size_14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                SliverToBoxAdapter(child: SizedBox(height: AppFontSize.size_25)),
              SliverToBoxAdapter(child: _buildCategorySelection(categories)),
              SliverToBoxAdapter(child: SizedBox(height: AppFontSize.size_25)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddingSize.padding_22,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: AppFontSize.size_270,
                    crossAxisSpacing: AppFontSize.size_15,
                    mainAxisSpacing: AppFontSize.size_20,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final drink = apiList[index];
                    final accentGradient =
                        _categoryGradients[index % _categoryGradients.length];
                    final accentLabelKey =
                        _intensityLabels[index % _intensityLabels.length];
                    return _DrinkCard(
                      key: ValueKey(drink.id ?? index),
                      drink: drink,
                      index: index,
                      accentGradient: accentGradient,
                      accentLabelKey: accentLabelKey,
                    );
                  }, childCount: apiList.length),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: AppFontSize.size_60)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context, UserModel? user) {
    final palette =
        _categoryGradients[selectedIndex % _categoryGradients.length];
    final double bigCircleSize = 220 + (selectedIndex * 6);
    final double smallCircleSize = 160 + (selectedIndex * 4);

    return SizedBox(
      height: AppFontSize.size_300,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: palette,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Positioned(
            top: -AppFontSize.size_80,
            right: -AppFontSize.size_40,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              width: bigCircleSize,
              height: bigCircleSize,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: AppFontSize.size_10,
            left: -AppFontSize.size_60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPaddingSize.padding_22,
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppFontSize.size_20),
                    // Text(
                    //   'home_location_label'.tr(),
                    //   style: TextStyle(
                    //     color: Colors.white.withValues(alpha: 0.75),
                    //     fontSize: AppFontSize.size_14,
                    //   ),
                    // ),
                    SizedBox(height: AppFontSize.size_6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        user?.userName?.isNotEmpty == true
                            ? user!.userName!
                            : 'guest'.tr(),
                        key: ValueKey<String>(user?.userName ?? 'guest'),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: AppFontSize.size_28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: AppFontSize.size_6),
                    // AnimatedSwitcher(
                    //   duration: const Duration(milliseconds: 400),
                    //   child: Text(
                    //     'home_location_value'.tr(),
                    //     key: ValueKey<int>(selectedIndex),
                    //     style: const TextStyle(
                    //       color: AppColors.whiteF1,
                    //       fontSize: AppFontSize.size_15,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: AppFontSize.size_25),
                    _buildSearchBar(context, palette),
                    const Spacer(),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: 0.9,
                      child: Row(
                        children: [
                          Icon(
                            Icons.blur_on,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: AppFontSize.size_18,
                          ),
                          SizedBox(width: AppFontSize.size_8),
                          Expanded(
                            child: Text(
                              'cart_intro'.tr(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: AppFontSize.size_14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppFontSize.size_25),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, List<Color> palette) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppFontSize.size_18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: AppFontSize.size_60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppFontSize.size_18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPaddingSize.padding_18,
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.white),
              SizedBox(width: AppFontSize.size_12),
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSize.size_16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'home_search_hint'.tr(),
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: AppFontSize.size_16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(width: AppFontSize.size_12),
              _buildFilterButton(context, palette),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, List<Color> palette) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('more_soon'.tr()),
            duration: const Duration(seconds: 2),
            backgroundColor: palette.first,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: AppFontSize.size_46,
        height: AppFontSize.size_46,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: palette.length > 1
                ? palette
                : [palette.first, palette.first],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppFontSize.size_14),
          boxShadow: [
            BoxShadow(
              color: palette.first.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.tune,
          color: AppColors.white,
          size: AppFontSize.size_20,
        ),
      ),
    );
  }

  
  Widget _buildCategorySelection(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddingSize.padding_22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'cat_all'.tr(),
            style: const TextStyle(
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppFontSize.size_12),
          SizedBox(
            height: AppFontSize.size_56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppPaddingSize.padding_12),
              itemBuilder: (context, index) {
                final bool isSelected = index == selectedIndex;
                final palette =
                    _categoryGradients[index % _categoryGradients.length];

                return GestureDetector(
                  onTap: () {
                    if (selectedIndex != index) {
                      setState(() => selectedIndex = index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.padding_16,
                      vertical: AppPaddingSize.padding_10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: palette,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : AppColors.white,
                      borderRadius: BorderRadius.circular(AppFontSize.size_24),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.greyE5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: palette.first.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.black,
                        fontSize: AppFontSize.size_15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      child: Text(categories[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

 
 
class _DrinkCard extends StatefulWidget {
  final DrinkModel drink;
  final int index;
  final List<Color> accentGradient;
  final String accentLabelKey;

  const _DrinkCard({
    super.key,
    required this.drink,
    required this.index,
    required this.accentGradient,
    required this.accentLabelKey,
  });

  @override
  State<_DrinkCard> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<_DrinkCard> {
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final drink = widget.drink;
    final tag = 'coffee-hero-${drink.id}';
    final imageUrl =
        'https://task.jasim-erp.com/api/dms/file/get/${drink.id}/?entitytype=1';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 520 + widget.index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final scale = lerpDouble(0.92, 1.0, value)!;
        final offset = (1 - value) * 26;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Transform.scale(
              scale: scale,
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppFontSize.size_18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppFontSize.size_18),
                    onTap: () {
                      Navigation.push(
                        CoffeeDetailScreen(heroTag: tag, drinkModel: drink),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppPaddingSize.padding_14,
                        AppPaddingSize.padding_14,
                        AppPaddingSize.padding_14,
                        AppPaddingSize.padding_18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: tag,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppFontSize.size_16,
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: AppColors.whiteF3,
                                        child: const Icon(
                                          Icons.local_cafe,
                                          color: AppColors.greyA4,
                                          size: AppFontSize.size_32,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: AppPaddingSize.padding_10,
                                      left: AppPaddingSize.padding_10,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppPaddingSize.padding_10,
                                          vertical: AppPaddingSize.padding_6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.45,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppFontSize.size_20,
                                          ),
                                        ),
                                        child: Text(
                                          widget.accentLabelKey.tr(),
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: AppFontSize.size_12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppFontSize.size_12),
                          Text(
                            drink.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppFontSize.size_17,
                              color: AppColors.black,
                            ),
                          ),
                          if ((drink.description ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: AppPaddingSize.padding_4,
                              ),
                              child: Text(
                                drink.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.xsecondaryColor,
                                  fontSize: AppFontSize.size_13,
                                ),
                              ),
                            ),
                          SizedBox(height: AppFontSize.size_12),
                          Row(
                            children: [
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  opacity: _adding ? 0.4 : 1,
                                  child: Text(
                                    'meta_serve_value'.tr(),
                                    style: TextStyle(
                                      color: AppColors.xsecondaryColor,
                                      fontSize: AppFontSize.size_12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              _AddToCartButton(
                                isLoading: _adding,
                                onPressed: _adding ? null : _handleAddToCart,
                                gradient: _gradient,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleAddToCart() async {
    setState(() => _adding = true);
    try {
      await context.read<CartCubit>().addToCart(
        CartItemModel(
          drink: widget.drink,
          quantity: 1,
          size: 'M',
          sugarPercentage: 0.50,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'toast_added_to_cart'.tr(
              namedArgs: {'name': widget.drink.name ?? ''},
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: _gradient.first,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('toast_failed_add'.tr()),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _adding = false);
      }
    }
  }

  List<Color> get _gradient => [
    widget.accentGradient[0],
    widget.accentGradient.length > 1
        ? widget.accentGradient[1]
        : widget.accentGradient[0],
  ];
}

class _AddToCartButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final List<Color> gradient;

  const _AddToCartButton({
    required this.isLoading,
    required this.onPressed,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradient.length > 1
        ? gradient
        : [gradient.first, gradient.first];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      width: isLoading ? AppFontSize.size_42 : AppFontSize.size_48,
      height: AppFontSize.size_42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppFontSize.size_16),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppFontSize.size_16),
          onTap: onPressed,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: AppFontSize.size_18,
                      height: AppFontSize.size_18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.add,
                      key: ValueKey('icon'),
                      color: AppColors.white,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

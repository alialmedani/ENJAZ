import 'dart:ui' as ui;
import 'dart:ui';

import 'package:enjaz/features/drink/data/model/drink_model.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:easy_localization/easy_localization.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final String heroTag;
  final DrinkModel drinkModel;

  const CoffeeDetailScreen({
    super.key,
    required this.heroTag,
    required this.drinkModel,
  });

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  String _size = 'M';
  int _qty = 1;
  SugarLevel _sugarLevel = SugarLevel.medium;
  bool _submitting = false;

  String get _imageUrl =>
      'https://task.jasim-erp.com/api/dms/file/get/${widget.drinkModel.id}/?entitytype=1';

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final heroHeight = media.size.height * 0.52;
    final accent = AppColors.orange;
    final description = widget.drinkModel.description?.trim();
    final tagline = _tagline(description);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF120B07),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2B1205),
                    Color(0xFF120B07),
                    Color(0xFF070302),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: Hero(
              tag: widget.heroTag,
              child: CachedImage(imageUrl: _imageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _GlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  _GlassIconButton(
                    icon: Icons.favorite_border_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.54,
            maxChildSize: 0.92,
            builder: (context, controller) {
              return _FrostedSheet(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const _DragHandle(),
                    Expanded(
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Text(
                            widget.drinkModel.name ??
                                'coffee_signature_title'.tr(),
                            style: AppTextStyle.getBoldStyle(
                              fontSize: AppFontSize.size_22,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tagline.isNotEmpty
                                ? tagline
                                : 'coffee_default_tagline'.tr(),
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_13,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _MetaInfoRow(items: _buildMetaInfo(description)),
                          const SizedBox(height: 28),
                          _SectionTitle(
                            title: 'section_choose_size_title'.tr(),
                            subtitle: 'section_choose_size_sub'.tr(),
                          ),
                          const SizedBox(height: 16),
                          _SizeSelector(
                            selected: _size,
                            onChanged: (code) => setState(() => _size = code),
                          ),
                          const SizedBox(height: 32),
                          _SectionTitle(
                            title: 'section_sugar_title'.tr(),
                            subtitle: 'section_sugar_sub'.tr(),
                          ),
                          const SizedBox(height: 14),
                          SugarAmountSection(
                            color: accent,
                            sugarLevel: _sugarLevel,
                            onChanged: (level) =>
                                setState(() => _sugarLevel = level),
                            pad: 28.0,
                          ),
                          const SizedBox(height: 28),
                          _SelectionSummary(
                            sizeLabel: _sizeLabel(_size),
                            sugarLabel: _sugarPhrase(_sugarLevel),
                            quantity: _qty,
                            accent: accent,
                          ),
                          const SizedBox(height: 32),
                          _SectionTitle(
                            title: 'section_story_title'.tr(),
                            subtitle: null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            description?.isNotEmpty == true
                                ? description!
                                : 'story_default_paragraph'.tr(),
                            style:
                                AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_13,
                                  color: AppColors.black23,
                                ).copyWith(
                                  color: AppColors.black23.withValues(
                                    alpha: 0.65,
                                  ),
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                    _BottomBar(
                      quantity: _qty,
                      onIncrement: () => setState(() => _qty++),
                      onDecrement: () =>
                          setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                      onAdd: _submitting ? null : () => _addToCart(),
                      submitting: _submitting,
                      accent: accent,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart() async {
    setState(() => _submitting = true);

    try {
      final cartItem = CartItemModel(
        drink: widget.drinkModel,
        quantity: _qty,
        size: _size,
        sugarPercentage: _sugarLevelToPercent(_sugarLevel),
      );

      await context.read<CartCubit>().addToCart(cartItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'toast_added_to_cart'.tr(
                namedArgs: {'name': widget.drinkModel.name ?? ''},
              ),
            ),
            backgroundColor: AppColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('toast_failed_add'.tr()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  double _sugarLevelToPercent(SugarLevel level) {
    switch (level) {
      case SugarLevel.none:
        return 0.0;
      case SugarLevel.light:
        return 0.25;
      case SugarLevel.medium:
        return 0.5;
      case SugarLevel.high:
        return 0.75;
    }
  }

  String _tagline(String? description) {
    if (description == null || description.isEmpty) {
      return '';
    }
    final sentences = description.split(RegExp(r'[.!?]'));
    for (final sentence in sentences) {
      final trimmed = sentence.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return description;
  }

  List<_MetaInfo> _buildMetaInfo(String? description) {
    return [
      _MetaInfo(
        icon: Icons.local_fire_department_outlined,
        label: 'meta_intensity'.tr(),
        value: _guessIntensity(description),
      ),
      _MetaInfo(
        icon: Icons.timer_outlined,
        label: 'meta_brew'.tr(),
        value: 'meta_brew_value'.tr(),
      ),
      _MetaInfo(
        icon: Icons.opacity_outlined,
        label: 'meta_serve'.tr(),
        value: 'meta_serve_value'.tr(),
      ),
    ];
  }

  String _guessIntensity(String? description) {
    final text = description?.toLowerCase() ?? '';
    if (text.contains('strong') || text.contains('bold')) {
      return 'meta_intensity_bold'.tr();
    }
    if (text.contains('light') || text.contains('smooth')) {
      return 'meta_intensity_smooth'.tr();
    }
    if (text.contains('dark')) {
      return 'meta_intensity_dark'.tr();
    }
    return 'meta_intensity_balanced'.tr();
  }

  String _sizeLabel(String code) {
    switch (code) {
      case 'S':
        return 'size_small_full'.tr(namedArgs: {'ml': '180'});
      case 'L':
        return 'size_large_full'.tr(namedArgs: {'ml': '360'});
      case 'M':
      default:
        return 'size_medium_full'.tr(namedArgs: {'ml': '240'});
    }
  }

  String _sugarPhrase(SugarLevel level) {
    switch (level) {
      case SugarLevel.none:
        return 'sugar_phrase_none'.tr();
      case SugarLevel.light:
        return 'sugar_phrase_light'.tr();
      case SugarLevel.medium:
        return 'sugar_phrase_medium'.tr();
      case SugarLevel.high:
        return 'sugar_phrase_high'.tr();
    }
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.white.withValues(alpha: 0.16),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 44,
              width: 44,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrostedSheet extends StatelessWidget {
  final Widget child;

  const _FrostedSheet({required this.child});

  @override
  Widget build(BuildContext context) {
    final radius = const BorderRadius.vertical(top: Radius.circular(36));
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: radius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 32,
                offset: const Offset(0, -12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 6,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.greyE5,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_16,
            color: AppColors.black23,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaInfoRow extends StatelessWidget {
  final List<_MetaInfo> items;

  const _MetaInfoRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF7EE), Color(0xFFFFE9D6)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: _MetaInfoTile(info: items[i])),
            if (i != items.length - 1)
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.orange.withValues(alpha: 0.25),
              ),
          ],
        ],
      ),
    );
  }
}

class _MetaInfoTile extends StatelessWidget {
  final _MetaInfo info;

  const _MetaInfoTile({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(info.icon, color: AppColors.orange, size: 22),
        const SizedBox(height: 6),
        Text(
          info.label,
          style: AppTextStyle.getRegularStyle(
            fontSize: AppFontSize.size_11,
            color: AppColors.secondPrimery,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          info.value,
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_13,
            color: AppColors.black23,
          ),
        ),
      ],
    );
  }
}

class _MetaInfo {
  final IconData icon;
  final String label;
  final String value;

  const _MetaInfo({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _SizeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _SizeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [
      _SizeOptionData(
        code: 'S',
        label: 'size_small'.tr(),
        description: 'size_ml'.tr(namedArgs: {'ml': '180'}),
      ),
      _SizeOptionData(
        code: 'M',
        label: 'size_medium'.tr(),
        description: 'size_ml'.tr(namedArgs: {'ml': '240'}),
      ),
      _SizeOptionData(
        code: 'L',
        label: 'size_large'.tr(),
        description: 'size_ml'.tr(namedArgs: {'ml': '360'}),
      ),
    ];

    return Row(
      children: options
          .map(
            (option) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _SizeOption(
                  option: option,
                  selected: option.code == selected,
                  onTap: () => onChanged(option.code),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SizeOptionData {
  final String code;
  final String label;
  final String description;

  const _SizeOptionData({
    required this.code,
    required this.label,
    required this.description,
  });
}

class _SizeOption extends StatelessWidget {
  final _SizeOptionData option;
  final bool selected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: selected
          ? [AppColors.orange, const Color(0xFFF0B27A)]
          : [Colors.white, Colors.white],
    );

    return AnimatedScale(
      scale: selected ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? AppColors.orange.withValues(alpha: 0.7)
                  : AppColors.greyE5,
              width: 1.6,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.orange.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_cafe_outlined,
                color: selected ? Colors.white : AppColors.orange,
                size: 26,
              ),
              const SizedBox(height: 10),
              Text(
                option.label,
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_13,
                  color: selected ? Colors.white : AppColors.black23,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                option.description,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_11,
                  color: selected
                      ? Colors.white.withValues(alpha: 0.86)
                      : AppColors.secondPrimery,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionSummary extends StatelessWidget {
  final String sizeLabel;
  final String sugarLabel;
  final int quantity;
  final Color accent;

  const _SelectionSummary({
    required this.sizeLabel,
    required this.sugarLabel,
    required this.quantity,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final cupsLabel = quantity == 1
        ? 'selection_cup'.tr(namedArgs: {'count': '$quantity'})
        : 'selection_cups'.tr(namedArgs: {'count': '$quantity'});

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.14), Colors.white],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selection_your_recipe'.tr(),
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _SummaryPill(
                icon: Icons.local_cafe,
                label: sizeLabel,
                accent: accent,
              ),
              _SummaryPill(
                icon: Icons.cake_outlined,
                label: sugarLabel,
                accent: accent,
              ),
              _SummaryPill(
                icon: Icons.format_list_numbered,
                label: cupsLabel,
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _SummaryPill({
    required this.icon,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.black23,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onAdd;
  final bool submitting;
  final Color accent;

  const _BottomBar({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAdd,
    required this.submitting,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
        child: Row(
          children: [
            _QuantityController(
              quantity: quantity,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
              accent: accent,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: accent.withValues(alpha: 0.4),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'add_to_cart'.tr(),
                          style: AppTextStyle.getBoldStyle(
                            fontSize: AppFontSize.size_15,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityController extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color accent;

  const _QuantityController({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Icons.remove, onTap: onDecrement, accent: accent),
          const SizedBox(width: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '$quantity',
              key: ValueKey<int>(quantity),
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_16,
                color: AppColors.black23,
              ),
            ),
          ),
          const SizedBox(width: 14),
          _QtyButton(icon: Icons.add, onTap: onIncrement, accent: accent),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        highlightShape: BoxShape.circle,
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: accent, size: 18),
        ),
      ),
    );
  }
}

/// ======================= sugar PERCENT (Arc + Slider) =======================
class SugarAmountSection extends StatelessWidget {
  final Color color;
  final SugarLevel sugarLevel;
  final ValueChanged<SugarLevel> onChanged;
  final double pad;

  const SugarAmountSection({
    super.key,
    required this.color,
    required this.sugarLevel,
    required this.onChanged,
    required this.pad,
  });

  void _updateFromLocal(Offset local, double width) {
    final left = pad;
    final right = width - pad;
    final dx = local.dx.clamp(left, right);
    final t = ((dx - left) / (right - left)).toDouble();

    SugarLevel newLevel;
    if (t <= 0.25) {
      newLevel = SugarLevel.none;
    } else if (t <= 0.50) {
      newLevel = SugarLevel.light;
    } else if (t <= 0.75) {
      newLevel = SugarLevel.medium;
    } else {
      newLevel = SugarLevel.high;
    }

    onChanged(newLevel);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _updateFromLocal(d.localPosition, w),
            onPanDown: (d) => _updateFromLocal(d.localPosition, w),
            onPanUpdate: (d) => _updateFromLocal(d.localPosition, w),
            child: CustomPaint(
              size: Size(w, 120),
              painter: SugarArcPainter(
                color: color,
                sugarLevel: sugarLevel,
                pad: pad,
                sugarWord: 'sugar_word'.tr(),
                labelNone: 'sugar_none'.tr(),
                labelLight: 'sugar_light'.tr(),
                labelMedium: 'sugar_medium'.tr(),
                labelHigh: 'sugar_high'.tr(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SugarArcPainter extends CustomPainter {
  final Color color;
  final SugarLevel sugarLevel;
  final double pad;

  // localized labels:
  final String sugarWord;
  final String labelNone;
  final String labelLight;
  final String labelMedium;
  final String labelHigh;

  SugarArcPainter({
    required this.color,
    required this.sugarLevel,
    this.pad = 24.0,
    required this.sugarWord,
    required this.labelNone,
    required this.labelLight,
    required this.labelMedium,
    required this.labelHigh,
  });

  double get percent {
    switch (sugarLevel) {
      case SugarLevel.none:
        return 0.0;
      case SugarLevel.light:
        return 0.33;
      case SugarLevel.medium:
        return 0.67;
      case SugarLevel.high:
        return 1.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * .68;
    final controlY = size.height * .24;
    final left = Offset(pad, baseY);
    final right = Offset(size.width - pad, baseY);
    final control = Offset(size.width / 2, controlY);

    final path = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(control.dx, control.dy, right.dx, right.dy);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, trackPaint);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final markerPositions = [0.0, 0.33, 0.67, 1.0];
    final markerPaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    for (final pos in markerPositions) {
      final tan = metrics.first.getTangentForOffset(metrics.first.length * pos);
      if (tan != null) {
        final p = tan.position;
        canvas.drawCircle(p, 3, markerPaint);
      }
    }

    final m = metrics.first;
    final total = m.length;
    final to = (total * percent.clamp(0.0, 1.0)).clamp(0.0, total);

    final fillPath = m.extractPath(0.0, to);
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(fillPath, fillPaint);

    final tan = m.getTangentForOffset(to);
    if (tan != null) {
      final p = tan.position;
      canvas.drawShadow(
        Path()..addOval(Rect.fromCircle(center: p, radius: 9)),
        Colors.black26,
        4,
        false,
      );
      canvas.drawCircle(p, 9, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        9,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = color,
      );
    }

    final levelLabel = _getSugarLevelDisplayName(sugarLevel);
    final painter = TextPainter(
      text: TextSpan(
        text: '$levelLabel $sugarWord',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
// textDirection: TextDirection.ltr, // بشرط عدم وجود تظليل للاسم
    )..layout();
    painter.paint(
      canvas,
      Offset((size.width - painter.width) / 2, size.height * 0.1),
    );
  }

  String _getSugarLevelDisplayName(SugarLevel level) {
    switch (level) {
      case SugarLevel.none:
        return labelNone;
      case SugarLevel.light:
        return labelLight;
      case SugarLevel.medium:
        return labelMedium;
      case SugarLevel.high:
        return labelHigh;
    }
  }

  @override
  bool shouldRepaint(covariant SugarArcPainter old) =>
      old.color != color ||
      old.sugarLevel != sugarLevel ||
      old.pad != pad ||
      old.sugarWord != sugarWord ||
      old.labelNone != labelNone ||
      old.labelLight != labelLight ||
      old.labelMedium != labelMedium ||
      old.labelHigh != labelHigh;
}

// lib/features/profile/widgets/signout_action_button.dart
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/core/constant/end_points/cashe_helper_constant.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';

class SignOutActionButton extends StatefulWidget {
  const SignOutActionButton({
    super.key,
    this.width,
    this.height = 48,
    this.alwaysAskConfirm = true,
  });

  final double? width;
  final double height;
  final bool alwaysAskConfirm;

  @override
  State<SignOutActionButton> createState() => _SignOutActionButtonState();
}

class _SignOutActionButtonState extends State<SignOutActionButton>
    with TickerProviderStateMixin {
  bool _busy = false;
  bool _toastActive = false;

  // ==== UX helpers ====
  Future<void> _showNeoToast(
    String text, {
    bool error = false,
    Duration? duration,
  }) async {
    if (!mounted || _toastActive) return;
    _toastActive = true;

    final overlay = Overlay.of(context);

    final g1 = error ? Colors.red.shade600 : AppColors.darkAccentColor;
    final g2 = error ? Colors.orange : AppColors.xorangeColor;

    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final curved = CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 16,
        right: 16,
        bottom: 28,
        child: FadeTransition(
          opacity: curved,
          child: _NeoToast(text: text, g1: g1, g2: g2),
        ),
      ),
    );

    overlay.insert(entry);
    await ctrl.forward();
    await Future.delayed(duration ?? const Duration(milliseconds: 1100));
    await ctrl.reverse();
    entry.remove();
    ctrl.dispose();
    _toastActive = false;
  }

  Future<bool> _confirmSheet() async {
    HapticFeedback.selectionClick();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ConfirmSheet(),
    );
    return ok == true;
  }

  Future<void> _logoutFlow() async {
    if (!mounted || _busy) return;
    setState(() => _busy = true);
    try {
      await CacheHelper.box.delete(accessToken);
      await CacheHelper.box.delete(refreshToken);
      await CacheHelper.box.delete('current_user_phone');
      await CacheHelper.box.delete('current_user_role');

      await _showNeoToast('signed_out'.tr());
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (r) => false,
      );
    } catch (_) {
      await _showNeoToast(
        'Something went wrong',
        error: true,
        duration: const Duration(milliseconds: 1400),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleTap() async {
    if (_busy) return;
    final ok = widget.alwaysAskConfirm ? await _confirmSheet() : true;
    if (!ok) return;
    await _logoutFlow();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = widget.height;
    final radius = h / 2;

    final g1 = AppColors.darkAccentColor;
    final g2 = AppColors.xorangeColor;

    return SizedBox(
      width: w,
      height: h,
      child: InkWell(
        onTap: () async {
          if (_busy) return;
          HapticFeedback.selectionClick();
          await _handleTap();
        },
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(colors: [g1, g2]),
            boxShadow: [
              BoxShadow(
                color: g1.withValues(alpha: 0.22),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glass layer خفيفة
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: Container(color: Colors.orange.withValues(alpha: 0.06)),
                ),
              ),
              // النص
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: _busy
                      ? const SizedBox(
                          key: ValueKey('loader'),
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'sign_out'.tr(),
                          key: const ValueKey('label'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==== Toast ====
class _NeoToast extends StatelessWidget {
  final String text;
  final Color g1, g2;
  const _NeoToast({required this.text, required this.g1, required this.g2});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مربع صغير متدرّج (بدون أيقونة)
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(colors: [g1, g2]),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==== BottomSheet التأكيد ====
class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet();

  @override
  Widget build(BuildContext context) {
    final g1 = AppColors.darkAccentColor;
    final g2 = AppColors.xorangeColor;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [g1, g2]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'sign_out_confirm_title'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'sign_out_confirm_body'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: g1,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('sign_out'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

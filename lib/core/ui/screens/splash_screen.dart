import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';
import 'package:enjaz/features/home/screen/Widgets/common_button.dart';
import 'package:flutter/material.dart';

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            // الخلفية: إما الصورة، أو بديل آمن إذا الصورة مفقودة
            SizedBox(
              height: size.height / 1.3,
              width: size.width,
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
                // ✅ fallback — ما بيخلّي الشاشة توقف لو الصورة مفقودة
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1A1A1A), Color(0xFF2B2B2B)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_cafe,
                    color: Colors.white54,
                    size: AppFontSize.size_96,
                  ),
                ),
              ),
            ),

            // تظليل خفيف لتوضيح النص فوق الخلفية
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.45),
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // المحتوى السفلي
            Positioned(
              right: 0,
              left: 0,
              bottom: AppPaddingSize.padding_45,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddingSize.padding_30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Fall in Love with Coffee in Blissful Delight!',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_28, // أخف من 35 لتفادي القص
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppPaddingSize.padding_10),
                    Text(
                      "Welcome to our cozy coffee corner, where every cup is a delightful for you.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_15,
                        color: AppColors.whiteF1,
                      ),
                    ),
                    const SizedBox(height: AppPaddingSize.padding_30),

                    // زر البدء
                    CommonButton(
                      title: 'Get Started',
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  static const Color primary = Color(0xFFD20808);
  static const Color ali = Color(0xFFD20808);

  // light Theme Colors
  static Color lightPrimaryColor = const Color(0xffF2F1F6); //background color
  static Color lightSecondaryColor = const Color(0xffFFFFFF);
  static Color lightAccentColor = const Color(0xff0277FA);
  static Color lightSubHeadingColor1 = const Color(0xff343F53);
  static Color background = const Color(0xFFe8e8e8);
  static Color lighterBackground = const Color(0xFFF1F1F1);
  static Color evenLighterBackground = const Color(0xFFF8F8F8);
  // dark theme color
  static Color darkPrimaryColor = const Color(0xff1E1E2C);
  static Color darkSecondaryColor = const Color(0xff2A2C3E);
  static Color darkAccentColor = const Color(0xff56A4FB);
  static Color darkSubHeadingColor1 = const Color(0xDDF2F1F6);
  //
  static Color xbackgroundColor = const Color(0xfff9f9f9);
  static Color xprimaryColor = const Color(0xffC67C4E);
  static Color xsecondaryColor = const Color(0xffA2A2A2);
  static Color xorangeColor = const Color(0xFFEC8600);
  static Color xpurpleColor = const Color(0xFF7C4DFF);
  static Color xbackgroundColor2 = const Color(0xffA2A2A2);
  
  // static Color xsecondaryColor = const Color(0xffA2A2A2);

  // when switch color
  Color get blackColor => brightness == Brightness.light
      ? lightSubHeadingColor1
      : darkSubHeadingColor1;
  Color get primaryColor =>
      brightness == Brightness.light ? primary : darkSubHeadingColor1;
  Color get secondaryColor => brightness == Brightness.light
      ? lightSecondaryColor
      : darkSubHeadingColor1;

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black1c = Color(0xFF1C1C1C);
  static const Color black28 = Color(0xFF282828);
  static const Color black23 = Color(0xFF232323);
  static const Color black14 = Color(0xFF141414);
  static const Color grey9A = Color(0xFF9A9A9A);
  static const Color greyDD = Color(0xFFDDE2E4);
  static const Color grey7F = Color(0xFF7F7F7F);
  static const Color grey9D = Color(0xFFD9D9D9);
  static const Color greyA4 = Color(0xFFA4A4A4);
  static const Color blueFace = Color(0xFF3D5A98);
  static const Color grey89 = Color(0xFF898989);
  static const Color grey8E = Color(0xFF8E8E8E);
  static const Color yellow = Color(0xFFF9C303);
  static const Color grey3B = Color(0xFF3B3B3B);
  static const Color whiteF1 = Color(0xFFF1F1F1);
  static const Color whiteF0 = Color(0xFFF0F0F0);
  static const Color secondPrimery = Color(0xFF727272);
  static const Color orange = Color(0xFFEC8600);
  static const Color grey3C = Color(0xFF3C3C3C);
  static const Color lightPrimary = Color(0xFF58BA6A);
  static const Color lightOrange = Color(0xFFF4A738);
  static const Color lightRed = Color(0xFFD20808);
  static const Color greyE5 = Color(0xFFE5E5E5);
  static const Color whiteF3 = Color(0xFFF3F3F3);
  static const Color lightXPrimary = Color(0xFFE8FFD0);
  static const Color green = Color(0xFF00B207);
  static const Color lightGreen = Color(0xFF5DFF43);
  static const Color lightYellow = Color(0xFFFFF853);
  static const Color lightXOrange = Color(0xFFE55725);
  static const Color primary7F = Color(0xFF7FFF7C);
  static const Color greyC1 = Color(0xFFC1C1C1);
  static const Color red = Color(0xFFB22222);
  static const Color green32 = Color(0xFF32CD32);
  static const Color greyA9 = Color(0xFFA9A9A9);
  static const Color babyBlue = Color(0xFF87CEEB);
  static const Color greyAD = Color(0xFFADADB4);
}

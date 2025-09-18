import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/features/auth/cubit/auth_cubit.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';
import 'package:enjaz/features/cart/cubit/cart_cubit.dart';
import 'package:enjaz/features/drink/cubit/drink_cubit.dart';
import 'package:enjaz/features/root/screen/root_screen.dart';
import 'package:enjaz/features/staff/cubit/ccubit1.dart';
import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/root/cubit/root_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/classes/keys.dart';
import 'core/constant/app_theme/app_theme.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RootCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => StaffOrdersCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => DrinkCubit()),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: false,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: Keys.navigatorKey,
            title: 'Task App',
            theme: appThemeData[AppTheme.light],
            // home: CacheHelper.token != null ? RootScreen() : LoginScreen(),
            home: RootScreen(),
          );
        },
      ),
    );
  }
}

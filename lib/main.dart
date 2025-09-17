import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/features/auth/cubit/auth_cubit.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';
import 'package:enjaz/features/home/screen/home_screen.dart';
import 'package:enjaz/features/staff/cubit/ccubit1.dart';
 import 'package:enjaz/features/home/screen/splash_screen1.dart';
import 'package:enjaz/features/order/cubit/corder_cubit.dart';
import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/root/cubit/root_cubit.dart';
import 'package:enjaz/features/root/screen/root_screen.dart';
import 'package:enjaz/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/classes/keys.dart';
import 'core/classes/notification.dart';
import 'core/constant/app_theme/app_theme.dart';
import 'core/ui/screens/splash_screen.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // prefs = await SharedPreferences.getInstance();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  // await FireBaseNotification().initNotification();
  // if (defaultTargetPlatform == TargetPlatform.android) {
   // }
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      saveLocale: true, // يخزّن آخر لغة اختارها المستخدم
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
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => StaffOrdersCubit()),

        BlocProvider(create: (context) => AuthCubit()),

        // BlocProvider(create: (context) => NotificationCubit()),
        // BlocProvider(create: (context) => ConfigrationCubit()),
        // BlocProvider(create: (context) => HomeCubit()),
        // BlocProvider(create: (context) => OfferCubit()),
        // BlocProvider(create: (context) => ShoppingCubit()),
        // BlocProvider(create: (context) => AuthCubit()),
        // BlocProvider(create: (context) => SearchCubit()),
        // BlocProvider(create: (context) => OrderCubit()),
        // BlocProvider(create: (context) => ProfileCubit()),
        // BlocProvider(create: (context) => SliderBannerCubit()),
        // BlocProvider(create: (context) => BrandCubit()),
        // BlocProvider(create: (context) => MatrixCubit()),
        // BlocProvider(create: (context) => WishlistCubit()),
        // BlocProvider(create: (context) => CartCubit()),

        // BlocProvider(create: (context) => SettingCubit()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: false,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            // locale: context.read<ProfileCubit>().initiallang,
             localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            navigatorKey: Keys.navigatorKey,
            title: 'Jeadr Center',
            theme: appThemeData[AppTheme.light],
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}

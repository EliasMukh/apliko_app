import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apliko/core/UI/router/router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/UI/styles/colors.dart';
import 'core/utils/lang.dart';
import 'core/utils/internet_info.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/presentation/pages/no_internet.dart';
import 'injectable/injecter.dart';
import 'main_config.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.env});
  final String env;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: AppLanguage.getSupportedLocales(),
      path: 'assets/translations',
      useOnlyLangCode: true,
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final _navKey = GlobalKey<NavigatorState>();
  static final AppRouter appRouter = AppRouter(navigatorKey: _navKey);
  static BuildContext get context =>
      appRouter.navigatorKey.currentState!.context;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _noInternetShown = false;
  Route<dynamic>? _noInternetRoute;

  @override
  void initState() {
    super.initState();
    // مستمع لحالة الاتصال لعرض/إخفاء شاشة عدم الاتصال
    InternetInfo.internetConnection.onStatusChange.listen((status) {
      if (!mounted) return;
      final isConnected = status == InternetStatus.connected;
      if (!isConnected && !_noInternetShown) {
        _showNoInternet();
      } else if (isConnected && _noInternetShown) {
        _dismissNoInternetIfAny();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<AuthCubit>())],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (_, __) {
            return MaterialApp.router(
              title: 'Financial Manager',
              scrollBehavior: MyCustomScrollBehavior(),
              routerDelegate: MyApp.appRouter.delegate(),
              routeInformationParser: MyApp.appRouter.defaultRouteParser(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Poppins',
                primaryColor: AppColors.primary,
                scaffoldBackgroundColor: AppColors.backgroundColor,
                dialogTheme: DialogTheme.of(
                  context,
                ).copyWith(surfaceTintColor: AppColors.white),
                colorScheme: const ColorScheme.light().copyWith(
                  primary: AppColors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showNoInternet() {
    final navigator = MyApp.appRouter.navigatorKey.currentState;
    if (navigator == null) return;
    if (_noInternetRoute != null) return;
    final route = PageRouteBuilder(
      opaque: true,
      pageBuilder:
          (_, __, ___) => PopScope(
            canPop: false,
            child: NoInternetScreen(
              onRetry: () async {
                final hasInternet = await InternetInfo.initState;
                if (hasInternet) {
                  _dismissNoInternetIfAny();
                }
              },
            ),
          ),
      transitionsBuilder:
          (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
    );
    _noInternetRoute = route;
    _noInternetShown = true;
    navigator.push(route);
  }

  void _dismissNoInternetIfAny() {
    final navigator = MyApp.appRouter.navigatorKey.currentState;
    if (navigator == null) return;
    if (_noInternetRoute != null) {
      navigator.removeRoute(_noInternetRoute!);
      _noInternetRoute = null;
      _noInternetShown = false;
    }
  }
}

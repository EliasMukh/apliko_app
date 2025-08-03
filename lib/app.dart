import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apliko/core/UI/router/router.dart';

import 'core/UI/styles/colors.dart';
import 'core/utils/lang.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
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
  @override
  void initState() {
    super.initState();
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
}

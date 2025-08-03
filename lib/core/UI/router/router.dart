import 'package:auto_route/auto_route.dart';
import 'package:apliko/core/UI/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: InitRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: ForgetPasswordRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: DeviceDetailsRoute.page),
  ];
}

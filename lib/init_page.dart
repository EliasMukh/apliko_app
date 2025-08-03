// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/UI/router/router.gr.dart';
import 'core/utils/lang.dart';
import 'core/utils/size_config.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';

@RoutePage()
class InitPage extends StatefulWidget {
  const InitPage();
  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AuthCubit>();
    cubit.tryLoginUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLanguage.init(context);
    SizeConfig.init(context);
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (_, state) {
          state.maybeWhen(
            logout: () {
              context.replaceRoute(const LoginRoute());
              FlutterNativeSplash.remove();
            },
            authenticated: () async {
              FlutterNativeSplash.remove();

              context.router.replace(const HomeRoute());
            },

            orElse: () {},
          );
        },
        child: SizedBox(),
      ),
    );
  }
}

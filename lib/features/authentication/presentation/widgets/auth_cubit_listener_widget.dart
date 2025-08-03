// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/UI/widgets/loading_widget.dart';
import '../../../../core/logical/errors/error_model.dart';
import '../../../../index.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';

class AuthCubitListenerWidget extends StatelessWidget {
  const AuthCubitListenerWidget({
    required this.orElseWidget,
    this.onError,
    this.onUpdate,
    this.errorWidget,
    this.loadingWidget,
  });
  final Widget Function(AuthCubit) orElseWidget;
  final Widget? errorWidget, loadingWidget;
  final void Function(String, ErrorDictionary?)? onError;
  final void Function(String?)? onUpdate;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (message, errorDic) {
            showErrorToast(message: message, context: context);
            onError?.call(message, errorDic);
          },
          updated: onUpdate,
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => orElseWidget(context.read<AuthCubit>()),
          loading: () => const LoadingWidget(),
          error: errorWidget != null ? (msg, errorDic) => errorWidget! : null,
        );
      },
    );
  }
}

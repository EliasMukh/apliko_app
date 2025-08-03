// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';
import 'package:apliko/core/UI/widgets/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/UI/widgets/loading_widget.dart';
import '../../domain/models/auth_params.dart';
import '../../../../core/UI/widgets/custom_widgets/custom_input_widgets.dart';
import '../../../../index.dart';
import '../../../../injectable/injecter.dart';
import '../cubit/auth_cubit.dart';

@RoutePage()
class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                state.maybeWhen(
                  error: (message, errorDic) {
                    showErrorToast(message: message, context: context);
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const _ForgetPasswordPageContent(),
                  loading: () => const LoadingWidget(),
                  updated: (_) => const EmailMessageWidget(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class EmailMessageWidget extends StatelessWidget {
  const EmailMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info, size: 27),
        const SizedBox(width: 10),
        TextTr('email_recovery_sent_hint', style: labelStyle()).flexible(),
      ],
    );
  }
}

class _ForgetPasswordPageContent extends StatefulWidget {
  const _ForgetPasswordPageContent();
  @override
  __ForgetPasswordPageContentState createState() =>
      __ForgetPasswordPageContentState();
}

class __ForgetPasswordPageContentState
    extends State<_ForgetPasswordPageContent> {
  AuthParams params = AuthParams.login();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            TextTr(
              'enter_your_email_and_well_send_you_a_link_to_reset_your_password',
              style: subLabelStyle(),
              align: TextAlign.center,
            ),
            5.hPercent.hSpace,
            CustomInputField(
              outerLabel: 'email',
              hint: 'email_address',
              onChanged: (value) {
                params.email = value?.trim();
              },
            ),
          ],
        ),
        2.hPercent.hSpace,
        CustomButton(
          onPressed: () {
            if (!params.email.notNullEmpty) {
              showErrorToast(message: 'email_is_required');
              return;
            }
            context.read<AuthCubit>().resetPassword(params.email!);
          },
          label: 'send_reset_link',
        ).flexible(),
      ],
    ).scrollable();
  }
}

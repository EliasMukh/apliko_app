// ignore_for_file: use_key_in_widget_constructors

import 'package:apliko/features/authentication/presentation/widgets/constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/UI/widgets/loading_widget.dart';
import '../../../../index.dart';
import '../../../../injectable/injecter.dart';
import '../cubit/auth_cubit.dart';

@RoutePage()
class SubmitRecoverPasswordPage extends StatefulWidget {
  const SubmitRecoverPasswordPage();

  @override
  State<SubmitRecoverPasswordPage> createState() =>
      _SubmitRecoverPasswordPageState();
}

class _SubmitRecoverPasswordPageState extends State<SubmitRecoverPasswordPage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.grey[50], // خلفية فاتحة ونظيفة
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 2,
          centerTitle: true,
          title: const Text(
            'Reset password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.maybeWhen(
              error: (message, errorDic) {
                showErrorToast(message: message, context: context);
              },
              updated: (_) {
                context.router.popUntilRoot();
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => _buildForm(),
              loading: () => const LoadingWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // أيقونة بتصميم أفضل
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: kPrimaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_reset, color: kPrimaryColor, size: 60),
              ),

              const SizedBox(height: 30),

              // عنوان بألوان أفضل
              Text(
                'Enter the code and new password',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // نص توضيحي
              Text(
                'Please enter the code sent to you and your new password',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // حقل الكود
              _buildTextField(
                controller: codeController,
                label: 'Verification Code',
                icon: Icons.verified_user,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the code';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // حقل كلمة المرور الجديدة
              _buildTextField(
                controller: newPasswordController,
                label: 'new password',
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // حقل تأكيد كلمة المرور
              _buildTextField(
                controller: confirmPasswordController,
                label: 'Confirm password',
                icon: Icons.lock,
                isPassword: true,
                validator: (value) {
                  if (value == null || value != newPasswordController.text) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // زر التأكيد
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().submitRecoverPassword(
                        codeController.text.trim(),
                        newPasswordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    // ignore: deprecated_member_use
                    shadowColor: kPrimaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'change password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: TextStyle(color: Colors.grey[800], fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

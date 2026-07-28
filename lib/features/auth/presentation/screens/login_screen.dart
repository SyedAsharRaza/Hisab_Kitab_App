import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/animated/primary_button.dart';
import '../../../../core/widgets/input/custom_text_field.dart';
import '../../../../core/widgets/snackbars/custom_snackbars.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;
    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      context.go(RouteNames.dashboard);
    } else {
      CustomSnackbars.showError(
        context,
        authProvider.errorMessage ?? 'Login failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == ViewStatus.loading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(40)),
                Text('Welcome Back', style: AppTextStyle.h1.copyWith(fontSize: context.sp(26))),
                SizedBox(height: context.h(8)),
                Text(
                  'Sign in to keep your ledger in sync',
                  style: AppTextStyle.bodyMedium.copyWith(fontSize: context.sp(14)),
                ),
                SizedBox(height: context.h(36)),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textHint),
                ),
                SizedBox(height: context.h(18)),
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
                ),
                SizedBox(height: context.h(32)),
                PrimaryButton(
                  label: 'Sign In',
                  isLoading: isLoading,
                  onPressed: () => _onLoginPressed(authProvider),
                ),
                SizedBox(height: context.h(20)),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(RouteNames.signup),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyle.bodyMedium.copyWith(fontSize: context.sp(14)),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
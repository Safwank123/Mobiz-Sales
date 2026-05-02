import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/common_widgets/custom_text_field.dart';
import '../../../../core/utils/app_prompts.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'sales@shop.com');
  final _passwordController = TextEditingController(text: '12345678');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginSubmitted(_emailController.text, _passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppPrompts.showSuccess(message: 'Login successful!');
            context.goNamed(RouteNames.dashboard.name);
          } else if (state is AuthFailure) {
            AppPrompts.showError(message: state.message);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 48.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kAppWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.kAppBorder),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kAppBlack.withValues(alpha: 0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.kAppPrimary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.kAppWhite,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'ShopEase',
                          textAlign: TextAlign.center,
                          style: AppTypography.style28Bold.copyWith(
                            color: AppColors.kAppOnSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Welcome back. Sign in to your\naccount to continue.',
                          textAlign: TextAlign.center,
                          style: AppTypography.style16Regular.copyWith(
                            color: AppColors.kAppTextSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: _emailController,
                          headingLabelText: 'Email Address',
                          hintText: 'sales@shop.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidators.emailValidator,
                          fillColor: AppColors.kAppInputBackground,
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: AppColors.kAppTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _passwordController,
                          headingLabelText: 'Password',
                          hintText: '••••••••',
                          isPassword: true,
                          validator: AppValidators.passwordValidator,
                          fillColor: AppColors.kAppInputBackground,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.kAppTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading ? null : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kAppPrimary,
                              foregroundColor: AppColors.kAppWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.kAppWhite,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Log In',
                                        style: AppTypography.style16SemiBold,
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.login),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

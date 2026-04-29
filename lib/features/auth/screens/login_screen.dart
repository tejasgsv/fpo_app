import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/state/platform_store.dart';
import '../services/auth_service.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  bool get _canSubmit {
    return AppValidators.userIdOrEmail(_userIdController.text) == null &&
        AppValidators.password(_passwordController.text) == null;
  }

  @override
  void initState() {
    super.initState();
    _userIdController.addListener(_refreshUi);
    _passwordController.addListener(_refreshUi);
  }

  @override
  void dispose() {
    _userIdController.removeListener(_refreshUi);
    _passwordController.removeListener(_refreshUi);
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _refreshUi() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final session = await widget.authService.login(
        userIdOrEmail: _userIdController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.authSuccess)),
      );

      if (session.role == PlatformRole.admin) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminDashboard, arguments: session);
        return;
      }

      if (session.accountStatus == FpoApplicationStatus.active) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard, arguments: session);
        return;
      }

      Navigator.of(context).pushReplacementNamed(AppRoutes.fpoAccessStatus, arguments: session);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.authError)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LoginHeader(
                onRegisterPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.registerFpo);
                },
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: AppCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.loginTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.loginSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Admin login: admin@fpo.local | FPO login: registration number or FPO name',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(height: 24),
                        AppTextField(
                          controller: _userIdController,
                          labelText: AppStrings.userIdLabel,
                          hintText: AppStrings.userIdHint,
                          validator: AppValidators.userIdOrEmail,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          labelText: AppStrings.passwordLabel,
                          hintText: AppStrings.passwordHint,
                          validator: AppValidators.password,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(AppStrings.passwordRecoverySoon)),
                              );
                            },
                            child: const Text(AppStrings.forgotPassword),
                          ),
                        ),
                        const SizedBox(height: 8),
                        PrimaryButton(
                          label: AppStrings.login,
                          isLoading: _isSubmitting,
                          onPressed: _canSubmit && !_isSubmitting ? _submit : null,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        SecondaryButton(
                          label: AppStrings.registerFpo,
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.registerFpo);
                          },
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
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.onRegisterPressed});

  final VoidCallback onRegisterPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.eco_outlined, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.loginHeaderTagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                      'Role-aware entry for super admin and approved FPO teams.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 172,
                child: FilledButton(
                  onPressed: onRegisterPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                  ),
                  child: const Text(AppStrings.registerFpo),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/auth_bloc.dart';
import '../../../../../routing/navigation_extension.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/auth_responsive_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to classes page after successful login
            context.goToClasses();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ResponsiveText(
                  state.message,
                  mobileSize: 14,
                  tabletSize: 16,
                  desktopSize: 18,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: ResponsiveContent(
            child: SingleChildScrollView(
              child: Padding(
                padding: ResponsiveHelper.getScreenPadding(context),
                child: Form(
                  key: _formKey,
                                  child: AuthPageLayout(
                  logo: _buildLogo(),
                  title: _buildTitle(),
                  subtitle: _buildSubtitle(),
                  form: _buildForm(),
                ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEmailField(),
        ResponsiveSpacing(mobile: 24, tablet: 28, desktop: 32),
        _buildPasswordField(),
        ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildLogo() {
    return AuthLogo(
      Icons.school,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTitle() {
    return AuthTitle('auth.sign_in'.tr());
  }

  Widget _buildSubtitle() {
    return AuthSubtitle('Welcome back, Teacher!');
  }

  Widget _buildEmailField() {
    return AuthTextField(
      controller: _emailController,
      labelText: 'auth.email'.tr(),
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'validation.required_field'.tr();
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'validation.invalid_email'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return AuthTextField(
      controller: _passwordController,
      labelText: 'auth.password'.tr(),
      prefixIcon: Icons.lock,
      obscureText: _obscurePassword,
      suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
      onSuffixIconPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'validation.required_field'.tr();
        }
        if (value.length < 8) {
          return 'validation.password_too_short'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthButton(
          'auth.sign_in'.tr(),
          onPressed: state is AuthLoading ? null : _handleLogin,
          isLoading: state is AuthLoading,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          width: double.infinity,
        );
      },
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
} 
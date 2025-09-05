import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../../../../core/routing/navigation_extension.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_title.dart';
import '../widgets/auth_subtitle.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate directly to home page after successful login
            context.goToHome();
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
    );
  }

  Widget _buildForm() {
    return const LoginForm();
  }

  Widget _buildLogo() {
    return AuthLogo(
      Icons.school,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTitle() {
    return AuthTitle('تسجيل الدخول');
  }

  Widget _buildSubtitle() {
    return const AuthSubtitle('مرحباً بعودتك يا معلمنا العزيز');
  }
} 
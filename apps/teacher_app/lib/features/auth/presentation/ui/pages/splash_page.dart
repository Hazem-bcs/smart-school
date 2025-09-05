import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../../../../core/routing/navigation_extension.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  
    context.read<AuthBloc>().add(CheckAuthStatus());
   
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
       
        if (state is AuthAuthenticated) {
          context.goToHome();
        } else if (state is AuthUnauthenticated) {
         context.goToLogin();
        } else if (state is AuthError) {
         context.goToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: ResponsiveContent(
          child: Center(
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(),
              tablet: _buildTabletLayout(),
              desktop: _buildDesktopLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(),
        ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
        _buildTitle(),
        ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
              _buildTitle(),
              ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
              _buildSubtitle(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
              _buildTitle(),
              ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
              _buildSubtitle(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return SizedBox(
            width: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 80, desktop: 100),
            height: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 80, desktop: 100),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: ResponsiveHelper.isMobile(context) ? 3 : 4,
            ),
          );
        }
        return ResponsiveIcon(
          Icons.school,
          mobileSize: 80,
          tabletSize: 100,
          desktopSize: 120,
          color: Colors.white,
        );
      },
    );
  }

  Widget _buildTitle() {
    return ResponsiveText(
      'تطبيق المعلم',
      mobileSize: 24,
      tabletSize: 28,
      desktopSize: 32,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return ResponsiveText(
      'تجربة تعليمية سهلة وسريعة',
      mobileSize: 14,
      tabletSize: 16,
      desktopSize: 18,
      style: TextStyle(
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }
} 
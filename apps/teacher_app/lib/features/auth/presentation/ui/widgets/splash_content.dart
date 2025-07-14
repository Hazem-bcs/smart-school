import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_title.dart';
import '../widgets/auth_subtitle.dart';
import '../../blocs/auth_bloc.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(context),
        ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
        _buildTitle(context),
        ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
        _buildSubtitle(context),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(context),
              ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
              _buildTitle(context),
              ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
              _buildSubtitle(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(context),
              ResponsiveSpacing(mobile: 32, tablet: 40, desktop: 48),
              _buildTitle(context),
              ResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24),
              _buildSubtitle(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
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
        return AuthLogo(
          Icons.school,
          color: Colors.white,
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AuthTitle(
      'app_title'.tr(),
      color: Colors.white,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return AuthSubtitle(
      'Teacher App',
      color: Colors.white70,
    );
  }
} 
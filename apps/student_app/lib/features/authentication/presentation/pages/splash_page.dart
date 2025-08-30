import 'dart:async';
import 'dart:math' as math;
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../blocs/auth_bloc.dart';
import '../cuibts/on_boarding_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../widgets/responsive/responsive_helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<AuthBloc>().add(CheckAuthenticationStatusEvent());
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });
    _backgroundController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _navigateBasedOnBoarding() async {
    final bool hasSeenOnboarding = await context.read<OnboardingCubit>().checkOnboardingStatus();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          !hasSeenOnboarding ? '/onBoarding' :  '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (state is Unauthenticated) {
          _navigateBasedOnBoarding();
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.accent,
                  ],
                  stops: [
                    0.0,
                    0.5,
                    1.0,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated background elements
                  ..._buildBackgroundElements(),
                  
                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with animations
                        _buildAnimatedLogo(),
                        
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 32, tablet: 40, desktop: 48)),
                        
                        // App name with animations
                        _buildAnimatedAppName(),
                        
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 32, desktop: 40)),
                        
                        // Loading indicator
                        _buildLoadingIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundElements() {
    return [
      // Floating circles
      Positioned(
        top: 10.h,
        left: 5.w,
        child: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _backgroundController.value * 2 * math.pi,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withAlpha((0.1 * 255).toInt()),
                ),
              ),
            );
          },
        ),
      ),
      
      Positioned(
        top: 20.h,
        right: 10.w,
        child: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Transform.rotate(
              angle: -_backgroundController.value * 2 * math.pi,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withAlpha((0.08 * 255).toInt()),
                ),
              ),
            );
          },
        ),
      ),
      
      Positioned(
        bottom: 15.h,
        left: 15.w,
        child: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _backgroundController.value * 1.5 * math.pi,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.05),
                ),
              ),
            );
          },
        ),
      ),
      
      // Gradient overlay
      Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              AppColors.primary.withOpacity(0.3),
              AppColors.primary.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/graduation-hat.png',
                color: AppColors.white,
                height: ResponsiveHelper.getIconSize(context, mobile: 80, tablet: 100, desktop: 120),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAppName() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textSlideAnimation.value),
          child: Opacity(
            opacity: _textOpacityAnimation.value,
            child: Column(
              children: [
                Text(
                  LocaleKeys.stellar.tr(),
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 32, tablet: 40, desktop: 48),
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: AppColors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
                Text(
                  'Smart School',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                    fontWeight: AppTextStyles.medium,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthChecking) {
          return Column(
            children: [
              SizedBox(
                width: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                height: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  backgroundColor: AppColors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
              Text(
                'جاري التحميل...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
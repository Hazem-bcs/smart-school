import 'dart:async';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../cuibts/on_boarding_cubit.dart';
import '../widgets/splash_logo_widget.dart';
import '../widgets/splash_app_name_widget.dart';
import '../widgets/splash_background_elements.dart';

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
                    AppColors.primary.withAlpha((0.7 * 255).toInt()),
                    AppColors.secondary.withAlpha((0.6 * 255).toInt()),
                    AppColors.accent.withAlpha((0.5 * 255).toInt()),
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
                  SplashBackgroundElements(
                    backgroundAnimation: _backgroundAnimation,
                  ),
                  
                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with animations
                        SplashLogoWidget(
                          scaleAnimation: _logoScaleAnimation,
                          opacityAnimation: _logoOpacityAnimation,
                        ),
                        
                        SizedBox(height: 32),
                        
                        // App name with animations
                        SplashAppNameWidget(
                          slideAnimation: _textSlideAnimation,
                          opacityAnimation: _textOpacityAnimation,
                        ),
                        
                        SizedBox(height: 24),
                        
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

  Widget _buildLoadingIndicator() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthChecking) {
          return _buildSimpleLoadingIndicator();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSimpleLoadingIndicator() {
    return Column(
      children: [
        // Simple animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final delay = index * 0.2;
                final animationValue = (_backgroundController.value + delay) % 1.0;
                final opacity = (0.3 + 0.7 * (1 - animationValue)).clamp(0.3, 1.0);
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withAlpha((opacity * 255).toInt()),
                  ),
                );
              },
            );
          }),
        ),
        
        SizedBox(height: 16),
        
        // Simple loading text
        Text(
          'جاري التحميل...',
          style: TextStyle(
            color: AppColors.white.withAlpha((0.8 * 255).toInt()),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
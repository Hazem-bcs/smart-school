import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:core/theme/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

/// Widget for splash page background elements with animations
class SplashBackgroundElements extends StatelessWidget {
  final Animation<double> backgroundAnimation;

  const SplashBackgroundElements({
    super.key,
    required this.backgroundAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating circles
        Positioned(
          top: 10.h,
          left: 5.w,
          child: AnimatedBuilder(
            animation: backgroundAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: backgroundAnimation.value * 2 * math.pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withAlpha((0.05 * 255).toInt()),
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
            animation: backgroundAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: -backgroundAnimation.value * 2 * math.pi,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withAlpha((0.04 * 255).toInt()),
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
            animation: backgroundAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: backgroundAnimation.value * 1.5 * math.pi,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withAlpha((0.03 * 255).toInt()),
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
                AppColors.primary.withAlpha((0.15 * 255).toInt()),
                AppColors.primary.withAlpha((0.05 * 255).toInt()),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

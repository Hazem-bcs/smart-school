import 'package:flutter/material.dart';
import '../theme/constants/app_colors.dart';
import '../theme/constants/app_text_styles.dart';

/// Unified Loading Indicator for the entire Smart School application
/// Provides consistent and beautiful loading states across all pages
class UnifiedLoadingIndicator extends StatefulWidget {
  final String? message;
  final LoadingType type;
  final double size;
  final bool showMessage;
  final Color? primaryColor;
  final Color? backgroundColor;

  const UnifiedLoadingIndicator({
    super.key,
    this.message,
    this.type = LoadingType.primary,
    this.size = 60.0,
    this.showMessage = true,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<UnifiedLoadingIndicator> createState() => _UnifiedLoadingIndicatorState();
}

class _UnifiedLoadingIndicatorState extends State<UnifiedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Rotation animation for spinner
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Pulse animation for scaling
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _fadeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final primaryColor = widget.primaryColor ?? 
        (isDark ? AppColors.darkAccentBlue : AppColors.primary);
    final backgroundColor = widget.backgroundColor ?? 
        (isDark ? AppColors.darkCardBackground : AppColors.white);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main loading indicator
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: _buildLoadingContent(primaryColor),
                ),
              );
            },
          ),
          
          // Message text
          if (widget.showMessage && widget.message != null) ...[
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    widget.message!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl, // Arabic text direction
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingContent(Color primaryColor) {
    switch (widget.type) {
      case LoadingType.primary:
        return _buildSpinner(primaryColor);
      case LoadingType.dots:
        return _buildDots(primaryColor);
      case LoadingType.pulse:
        return _buildPulse(primaryColor);
      case LoadingType.wave:
        return _buildWave(primaryColor);
      case LoadingType.ripple:
        return _buildRipple(primaryColor);
    }
  }

  Widget _buildSpinner(Color primaryColor) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: CustomPaint(
            painter: SpinnerPainter(primaryColor),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }

  Widget _buildDots(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue = (_pulseController.value + delay) % 1.0;
            final scale = 0.5 + (0.5 * animationValue);
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Transform.scale(scale: scale),
            );
          },
        );
      }),
    );
  }

  Widget _buildPulse(Color primaryColor) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: widget.size * 0.6,
          height: widget.size * 0.6,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildWave(Color primaryColor) {
    return CustomPaint(
      painter: WavePainter(primaryColor, _pulseController),
      size: Size(widget.size, widget.size),
    );
  }

  Widget _buildRipple(Color primaryColor) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final delay = index * 0.3;
            final animationValue = (_pulseController.value + delay) % 1.0;
            final scale = 0.3 + (0.7 * animationValue);
            final opacity = 1.0 - animationValue;
            
            return Transform.scale(
              scale: scale,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor.withOpacity(opacity),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Different types of loading animations
enum LoadingType {
  primary,  // Spinning circle
  dots,     // Animated dots
  pulse,    // Pulsing circle
  wave,     // Wave animation
  ripple,   // Ripple effect
}

/// Custom painter for spinner animation
class SpinnerPainter extends CustomPainter {
  final Color color;
  
  SpinnerPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    
    // Draw arc with gradient opacity
    for (int i = 0; i < 8; i++) {
      final startAngle = i * (3.14159 / 4);
      final sweepAngle = 3.14159 / 6;
      final opacity = 0.2 + (0.8 * (i / 8));
      
      paint.color = color.withOpacity(opacity);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for wave animation
class WavePainter extends CustomPainter {
  final Color color;
  final AnimationController controller;
  
  WavePainter(this.color, this.controller) : super(repaint: controller);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Draw multiple waves with different phases
    for (int i = 0; i < 3; i++) {
      final phase = controller.value + (i * 0.3);
      final waveRadius = radius + (10 * (0.5 + 0.5 * (phase % 1.0)));
      final opacity = 0.3 + (0.7 * (1.0 - (phase % 1.0)));
      
      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(center, waveRadius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Convenience widget for common loading states
class SmartSchoolLoading extends StatelessWidget {
  final String? message;
  final LoadingType type;
  final double size;
  final bool showMessage;

  const SmartSchoolLoading({
    super.key,
    this.message,
    this.type = LoadingType.primary,
    this.size = 60.0,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedLoadingIndicator(
      message: message,
      type: type,
      size: size,
      showMessage: showMessage,
    );
  }
}

/// Loading indicator with default message for common scenarios
class CommonLoadingStates {
  static Widget initialLoading() => const SmartSchoolLoading(
    message: 'جاري التحميل...',
    type: LoadingType.primary,
  );
  
  static Widget dataLoading() => const SmartSchoolLoading(
    message: 'جاري جلب البيانات...',
    type: LoadingType.dots,
  );
  
  static Widget savingData() => const SmartSchoolLoading(
    message: 'جاري الحفظ...',
    type: LoadingType.pulse,
  );
  
  static Widget processing() => const SmartSchoolLoading(
    message: 'جاري المعالجة...',
    type: LoadingType.wave,
  );
  
  static Widget connecting() => const SmartSchoolLoading(
    message: 'جاري الاتصال...',
    type: LoadingType.ripple,
  );
}

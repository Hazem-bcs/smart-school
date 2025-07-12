import 'package:flutter/material.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';

class QuickActionButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;

  const QuickActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? _scaleAnimation.value : 1.0,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: ResponsiveHelper.getButtonHeight(context),
                decoration: BoxDecoration(
                  color: widget.isPrimary
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context),
                  ),
                  border: widget.isPrimary
                      ? null
                      : Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isPrimary
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      blurRadius: _isPressed ? 4 : 8,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        ResponsiveIcon(
                          widget.icon!,
                          mobileSize: 18,
                          tabletSize: 20,
                          desktopSize: 22,
                          color: widget.isPrimary
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
                      ],
                      ResponsiveText(
                        widget.text,
                        mobileSize: 14,
                        tabletSize: 16,
                        desktopSize: 18,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isPrimary
                              ? Colors.white
                              : Theme.of(context).primaryColor,
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
    );
  }
} 
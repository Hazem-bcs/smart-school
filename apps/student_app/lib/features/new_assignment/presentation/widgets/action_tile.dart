import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';


import '../../../../widgets/responsive/responsive_helper.dart';

class ActionTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const ActionTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile>
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
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
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(
                  bottom: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
                ),
                padding: ResponsiveHelper.getScreenPadding(context),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? (isDark ? AppColors.darkCardBackground : Colors.grey[50]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? AppColors.darkGradientStart.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getSpacing(context, mobile: 10, tablet: 14, desktop: 18),
                      ),
                      decoration: BoxDecoration(
                        color: (widget.iconColor ?? (isDark ? AppColors.darkAccentBlue : theme.primaryColor)).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        size: ResponsiveHelper.getIconSize(context, mobile: 22, tablet: 26, desktop: 30),
                        color: widget.iconColor ?? (isDark ? AppColors.darkAccentBlue : theme.primaryColor),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 14, tablet: 18, desktop: 22)),
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: ResponsiveHelper.getIconSize(context, mobile: 18, tablet: 20, desktop: 22),
                      color: isDark ? AppColors.darkSecondaryText : Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 
import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'package:core/theme/constants/app_colors.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;

  const SectionTitle({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
  });

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            top: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 32, desktop: 40),
            bottom: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getSpacing(context, mobile: 10, tablet: 14, desktop: 18),
                  ),
                  decoration: BoxDecoration(
                    color: (widget.iconColor ?? (isDark ? AppColors.darkAccentBlue : theme.primaryColor)).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (widget.iconColor ?? (isDark ? AppColors.darkAccentBlue : theme.primaryColor)).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.icon!,
                    size: ResponsiveHelper.getIconSize(context, mobile: 22, tablet: 26, desktop: 30),
                    color: widget.iconColor ?? (isDark ? AppColors.darkAccentBlue : theme.primaryColor),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 14, tablet: 18, desktop: 22)),
              ],
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : theme.textTheme.titleLarge?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
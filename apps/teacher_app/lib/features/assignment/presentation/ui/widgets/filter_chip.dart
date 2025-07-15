import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'package:core/theme/constants/app_colors.dart';

class FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<FilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(FilterChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
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
        final selectedColor = isDark ? AppColors.info.withOpacity(0.15) : AppColors.info.withOpacity(0.12);
        final unselectedColor = isDark ? AppColors.darkCardBackground : theme.cardColor;
        final selectedBorder = isDark ? AppColors.info : AppColors.primary;
        final unselectedBorder = isDark ? AppColors.darkCardBackground : theme.dividerColor.withOpacity(0.1);
        final selectedText = isDark ? AppColors.info : AppColors.primary;
        final unselectedText = isDark ? theme.textTheme.bodyMedium?.color : theme.textTheme.bodyMedium?.color;
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.only(
                right: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
              ),
              decoration: BoxDecoration(
                color: widget.isSelected ? selectedColor : unselectedColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
                border: Border.all(
                  color: widget.isSelected ? selectedBorder : unselectedBorder,
                  width: widget.isSelected ? 2 : 1,
                ),
              ),
              child: ResponsiveText(
                widget.label,
                mobileSize: 14,
                tabletSize: 16,
                desktopSize: 18,
                style: TextStyle(
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected ? selectedText : unselectedText,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 
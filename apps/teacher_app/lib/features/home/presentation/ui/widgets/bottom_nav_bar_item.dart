import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

class BottomNavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const BottomNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<BottomNavBarItem> createState() => _BottomNavBarItemState();
}

class _BottomNavBarItemState extends State<BottomNavBarItem>
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
      end: 1.1,
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
  void didUpdateWidget(BottomNavBarItem oldWidget) {
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8),
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResponsiveIcon(
                    widget.icon,
                    mobileSize: 24,
                    tabletSize: 28,
                    desktopSize: 32,
                    color: Color.lerp(
                      Colors.grey[600]!,
                      Theme.of(context).primaryColor,
                      _colorAnimation.value,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2, tablet: 4, desktop: 6)),
                  ResponsiveText(
                    widget.label,
                    mobileSize: 10,
                    tabletSize: 12,
                    desktopSize: 14,
                    style: TextStyle(
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: Color.lerp(
                        Colors.grey[600]!,
                        Theme.of(context).primaryColor,
                        _colorAnimation.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 
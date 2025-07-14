import 'package:flutter/material.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import 'package:core/theme/constants/app_colors.dart';

class AssignmentListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback? onTap;
  final int index;

  const AssignmentListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.onTap,
    required this.index,
  });

  @override
  State<AssignmentListTile> createState() => _AssignmentListTileState();
}

class _AssignmentListTileState extends State<AssignmentListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

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
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // تأخير بدء الحركة حسب الترتيب
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
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
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8),
              ),
              padding: ResponsiveHelper.getScreenPadding(context),
              decoration: BoxDecoration(
                color: _isHovered
                    ? theme.primaryColor.withOpacity(0.05)
                    : (isDark ? AppColors.darkCardBackground : theme.cardColor),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
                border: Border.all(
                  color: _isHovered
                      ? theme.primaryColor.withOpacity(0.2)
                      : (isDark ? AppColors.darkCardBackground : theme.dividerColor.withOpacity(0.1)),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                    blurRadius: _isHovered ? 8 : 4,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // أيقونة الحالة
                  Container(
                    width: ResponsiveHelper.getIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                    height: ResponsiveHelper.getIconSize(context, mobile: 40, tablet: 48, desktop: 56),
                    decoration: BoxDecoration(
                      color: widget.isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(context),
                      ),
                    ),
                    child: Icon(
                      widget.isCompleted ? Icons.check_circle : Icons.pending,
                      color: widget.isCompleted ? Colors.green : Colors.orange,
                      size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context)),
                  // المحتوى
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          widget.title,
                          mobileSize: 16,
                          tabletSize: 18,
                          desktopSize: 20,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                        ResponsiveText(
                          widget.subtitle,
                          mobileSize: 14,
                          tabletSize: 16,
                          desktopSize: 18,
                          style: TextStyle(
                            color: isDark ? theme.textTheme.bodyMedium?.color : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // سهم التنقل
                  ResponsiveIcon(
                    Icons.arrow_forward_ios,
                    mobileSize: 16,
                    tabletSize: 18,
                    desktopSize: 20,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';

class AssignmentTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final int index;

  const AssignmentTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    required this.index,
  });

  @override
  State<AssignmentTile> createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<AssignmentTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // تأخير بدء الحركة حسب الترتيب
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: FadeTransition(
            opacity: _fadeAnimation,
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
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context),
                    ),
                    border: Border.all(
                      color: _isHovered 
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                        blurRadius: _isHovered ? 8 : 4,
                        offset: Offset(0, _isHovered ? 4 : 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // الأيقونة
                      Container(
                        padding: EdgeInsets.all(
                          ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getBorderRadius(context),
                          ),
                        ),
                        child: ResponsiveIcon(
                          widget.icon,
                          mobileSize: 20,
                          tabletSize: 24,
                          desktopSize: 28,
                          color: Theme.of(context).primaryColor,
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
                              mobileSize: 14,
                              tabletSize: 16,
                              desktopSize: 18,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.titleMedium?.color,
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2, tablet: 4, desktop: 6)),
                            ResponsiveText(
                              widget.subtitle,
                              mobileSize: 12,
                              tabletSize: 14,
                              desktopSize: 16,
                              style: TextStyle(
                                color: Colors.grey[600],
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
      },
    );
  }
} 
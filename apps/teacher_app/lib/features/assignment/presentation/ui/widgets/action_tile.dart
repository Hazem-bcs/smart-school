import 'package:flutter/material.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';

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
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context),
                  ),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                      ),
                      decoration: BoxDecoration(
                        color: (widget.iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(context),
                        ),
                      ),
                      child: ResponsiveIcon(
                        widget.icon,
                        mobileSize: 20,
                        tabletSize: 24,
                        desktopSize: 28,
                        color: widget.iconColor ?? Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
                    Expanded(
                      child: ResponsiveText(
                        widget.text,
                        mobileSize: 14,
                        tabletSize: 16,
                        desktopSize: 18,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
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
        );
      },
    );
  }
} 
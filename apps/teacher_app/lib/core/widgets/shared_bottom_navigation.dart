import 'package:flutter/material.dart';
import '../core/responsive_helper.dart';
import '../core/responsive_widgets.dart';
import '../routing/navigation_extension.dart';

class SharedBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const SharedBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  void _onNavItemTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        // Dashboard
        context.pushReplacementAllNamed('/home');
        break;
      case 1:
        // Assignments
        context.pushReplacementAllNamed('/assignments');
        break;
      case 2:
        // Schedule
        context.pushReplacementAllNamed('/schedule');
        break;
      case 3:
        // Settings
        context.pushReplacementAllNamed('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.dashboard, 'activeIcon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.assignment, 'activeIcon': Icons.assignment, 'label': 'Assignments'},
      {'icon': Icons.calendar_today, 'activeIcon': Icons.calendar_today, 'label': 'Schedule'},
      {'icon': Icons.settings, 'activeIcon': Icons.settings, 'label': 'Settings'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
          ),
          child: ResponsiveLayout(
            mobile: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildNavItems(context, navItems),
            ),
            tablet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildNavItems(context, navItems),
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildNavItems(context, navItems),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context, List<Map<String, dynamic>> navItems) {
    return navItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == currentIndex;

      return GestureDetector(
        onTap: () => _onNavItemTap(context, index),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : const Color(0xFF4E7397),
                size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2, tablet: 4, desktop: 6)),
              ResponsiveText(
                item['label'] as String,
                mobileSize: 10,
                tabletSize: 12,
                desktopSize: 14,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : const Color(0xFF4E7397),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
} 
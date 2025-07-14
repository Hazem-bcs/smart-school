import 'package:flutter/material.dart';
import '../../../../../core/responsive_helper.dart';
import 'package:core/theme/constants/app_colors.dart';

class AssignmentsSearchField extends StatelessWidget {
  final TextEditingController controller;

  const AssignmentsSearchField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
        vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark ? AppColors.info : AppColors.primary,
            size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search assignments',
                border: InputBorder.none,
                isDense: true,
              ),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
} 
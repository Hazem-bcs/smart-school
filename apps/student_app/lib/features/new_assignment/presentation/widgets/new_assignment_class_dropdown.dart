import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';

import '../../../../widgets/responsive/responsive_helper.dart';
import '../widgets/section_title.dart';
import 'decorated_section_container.dart';

class NewAssignmentClassDropdown extends StatelessWidget {
  final String? selectedClass;
  final List<String> availableClasses;
  final ValueChanged<String?> onChanged;
  final bool isDark;
  final String? Function(String?)? validator;
  const NewAssignmentClassDropdown({super.key, required this.selectedClass, required this.availableClasses, required this.onChanged, required this.isDark, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Target Classes/Students', icon: Icons.groups, iconColor: isDark ? AppColors.secondary : AppColors.secondary),
        DecoratedSectionContainer(
          isDark: isDark,
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select Classes/Students',
              filled: true,
              fillColor: isDark ? Colors.transparent : Colors.grey[50],
              labelStyle: TextStyle(
                color: isDark ? AppColors.darkAccentBlue : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  width: 2.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
              ),
            ),
            dropdownColor: isDark ? AppColors.darkCardBackground : AppColors.gray50,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              size: 28,
            ),
            value: selectedClass,
            items: availableClasses.map((String classItem) {
              return DropdownMenuItem<String>(
                value: classItem,
                child: Text(
                  classItem,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
} 
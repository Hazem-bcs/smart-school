import 'package:flutter/material.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';

class AssignmentsEmptyState extends StatelessWidget {
  final String searchQuery;
  const AssignmentsEmptyState({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: ResponsiveHelper.getIconSize(context, mobile: 80, tablet: 100, desktop: 120),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          ResponsiveText(
            searchQuery.isNotEmpty ? 'لا توجد نتائج مطابقة' : 'لا توجد واجبات بعد',
            mobileSize: 18,
            tabletSize: 20,
            desktopSize: 22,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
          ResponsiveText(
            searchQuery.isNotEmpty 
                ? 'جرّب تعديل البحث أو عوامل التصفية'
                : 'ابدأ بإنشاء أول واجب لك',
            mobileSize: 14,
            tabletSize: 16,
            desktopSize: 18,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
} 
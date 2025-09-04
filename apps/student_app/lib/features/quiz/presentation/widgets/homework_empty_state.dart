import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';

class HomeworkEmptyState extends StatelessWidget {
  final bool isDark;

  const HomeworkEmptyState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 50,
                color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد واجبات متاحة',
              style: TextStyle(
                fontSize: 22,
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'تحقق لاحقاً من وجود واجبات جديدة',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

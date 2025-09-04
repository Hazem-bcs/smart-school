import 'package:flutter/material.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.lgPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('المعلومات الشخصية', theme, isDark),
          const SizedBox(height: AppSpacing.lg),
          
          // Personal Information Cards
          _buildInfoCard(
            icon: Icons.email,
            title: 'البريد الإلكتروني',
            subtitle: user.email,
            color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          
          _buildInfoCard(
            icon: Icons.phone,
            title: 'رقم الهاتف',
            subtitle: user.phone ?? 'غير محدد',
            color: isDark ? AppColors.darkAccentPurple : AppColors.accent,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          
          _buildInfoCard(
            icon: Icons.location_on,
            title: 'العنوان',
            subtitle: user.address ?? 'غير محدد',
            color: isDark ? AppColors.darkSuccess : AppColors.secondary,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          
          _buildInfoCard(
            icon: Icons.cake,
            title: 'تاريخ الميلاد',
            subtitle: _formatDate(user.dateBirth),
            color: isDark ? AppColors.darkWarning : AppColors.gray600,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Family Information Section
          _buildSectionTitle('معلومات العائلة', theme, isDark),
          const SizedBox(height: AppSpacing.lg),
          
          _buildInfoCard(
            icon: Icons.person,
            title: 'اسم الأب',
            subtitle: user.fatherName ?? 'غير محدد',
            color: isDark ? AppColors.darkIcon : AppColors.gray500,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.md),
          
          _buildInfoCard(
            icon: Icons.person,
            title: 'اسم الأم',
            subtitle: user.motherName ?? 'غير محدد',
            color: isDark ? AppColors.darkSecondaryText : AppColors.info,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme, bool isDark) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: isDark ? AppColors.darkPrimaryText : AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
        borderRadius: AppSpacing.baseBorderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: AppSpacing.basePadding,
        child: Row(
          children: [
            Container(
              padding: AppSpacing.mdPadding,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: AppSpacing.mdBorderRadius,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isDark ? AppColors.darkPrimaryText : AppColors.gray900,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'غير محدد';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

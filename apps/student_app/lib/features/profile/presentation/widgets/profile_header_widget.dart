import 'package:flutter/material.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.darkGradientStart,
                AppColors.darkGradientEnd,
                AppColors.darkAccentBlue,
              ]
            : [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
              ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.lgPadding,
          child: Column(
            children: [
              _buildProfilePicture(theme, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildUserName(theme, isDark),
              const SizedBox(height: AppSpacing.sm),
              _buildUserGrade(theme, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildUserStats(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: isDark ? AppColors.darkCardBackground : AppColors.white,
        backgroundImage: user.profilePhotoUrl != null
            ? NetworkImage(user.profilePhotoUrl!)
            : const AssetImage("assets/images/user_3.png") as ImageProvider,
      ),
    );
  }

  Widget _buildUserName(ThemeData theme, bool isDark) {
    return Text(
      user.name ?? 'اسم الطالب',
      style: AppTextStyles.h2.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserGrade(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: AppSpacing.lgBorderRadius,
      ),
      child: Text(
        '${user.grade ?? ''} - ${user.classroom ?? ''} ${user.section ?? ''}',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildUserStats(ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.school,
          label: 'الصف',
          value: user.classroom ?? 'غير محدد',
          isDark: isDark,
        ),
        _buildStatItem(
          icon: Icons.person,
          label: 'الجنس',
          value: user.gender == 'Male' ? 'ذكر' : 'أنثى',
          isDark: isDark,
        ),
        _buildStatItem(
          icon: Icons.flag,
          label: 'الجنسية',
          value: user.nationality ?? 'غير محدد',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          padding: AppSpacing.mdPadding,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: AppSpacing.baseBorderRadius,
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
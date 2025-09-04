import 'package:flutter/material.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import '../pages/edit_profile_page.dart';

class ProfileActionsWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileActionsWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.lgPadding,
      child: Column(
        children: [
          _buildEditProfileButton(context, isDark),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
            : [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: AppSpacing.baseBorderRadius,
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProfilePage(currentUser: user),
            ),
          );
        },
        icon: Icon(
          Icons.edit,
          color: AppColors.white,
          size: 24,
        ),
        label: Text(
          'تعديل الملف الشخصي',
          style: AppTextStyles.buttonPrimary.copyWith(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class SupportSection extends StatelessWidget {
  final AnimationController cardAnimationController;
  final Animation<double> scaleAnimation;
  final VoidCallback onShowLogoutDialog;

  const SupportSection({
    super.key,
    required this.cardAnimationController,
    required this.scaleAnimation,
    required this.onShowLogoutDialog,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'الدعم والمساعدة'),
        _buildModernSupportCard(context, theme, isDark),
      ],
    );
  }

  Widget _buildModernSupportCard(BuildContext context, ThemeData theme, bool isDark) {
    return ModernEffects.neumorphism(
      isDark: isDark,
      distance: 6.0,
      intensity: 0.1,
      borderRadius: BorderRadius.circular(20),
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
      child: Column(
        children: [
          _buildModernSupportTile(
            context: context,
            theme: theme,
            isDark: isDark,
            icon: Icons.help_outline_rounded,
            iconColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
            title: 'المساعدة والأسئلة الشائعة',
            subtitle: 'احصل على المساعدة واعثر على الإجابات',
            onTap: () => Navigator.pushNamed(context, '/help-faq'),
          ),
          _buildDivider(isDark),
          _buildModernSupportTile(
            context: context,
            theme: theme,
            isDark: isDark,
            icon: Icons.info_outline_rounded,
            iconColor: isDark ? AppColors.darkSuccess : AppColors.success,
            title: 'عن التطبيق',
            subtitle: 'الإصدار 1.0.0',
            onTap: () => Navigator.pushNamed(context, '/about-app'),
          ),
          _buildDivider(isDark),
          _buildModernSupportTile(
            context: context,
            theme: theme,
            isDark: isDark,
            icon: Icons.logout_rounded,
            iconColor: isDark ? AppColors.darkDestructive : AppColors.error,
            title: 'تسجيل الخروج',
            subtitle: 'تسجيل الخروج من حسابك',
            onTap: onShowLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSupportTile({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: iconColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: ResponsiveHelper.getIconSize(context, mobile: 22, tablet: 24, desktop: 26),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      color: isDestructive 
                        ? iconColor 
                        : (isDark ? AppColors.darkPrimaryText : AppColors.gray800),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkElevatedSurface : AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            isDark ? AppColors.darkDivider.withOpacity(0.3) : AppColors.gray200.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(
          context,
          mobile: 20,
          tablet: 24,
          desktop: 28,
        ),
        vertical: ResponsiveHelper.getSpacing(
          context,
          mobile: 20,
          tablet: 24,
          desktop: 28,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
          letterSpacing: 0.5,
          color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
        ),
      ),
    );
  }
}


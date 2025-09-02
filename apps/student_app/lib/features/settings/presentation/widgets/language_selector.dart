import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _selectedLanguage = 'العربية';

  final List<Map<String, String>> _languages = [
    {'name': 'العربية', 'code': 'ar', 'flag': '🇸🇦'},
    {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ModernEffects.glassmorphism(
      isDark: isDark,
      opacity: 0.95,
      blur: 20.0,
      borderOpacity: 0.3,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(isDark),
          _buildHeader(context, theme, isDark),
          _buildLanguagesList(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Container(
      margin: EdgeInsets.only(top: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? AppColors.darkDivider : AppColors.gray300,
            isDark ? AppColors.darkSecondaryText : AppColors.gray400,
          ],
        ),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
            decoration: BoxDecoration(
              gradient: ModernEffects.modernGradient(
                isDark: isDark,
                type: GradientType.primary,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: ModernEffects.modernShadow(
                isDark: isDark,
                type: ShadowType.soft,
              ),
            ),
            child: Icon(
              Icons.language_rounded,
              color: AppColors.white,
              size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          Expanded(
            child: Text(
              'اختر اللغة',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          _buildCloseButton(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkElevatedSurface : AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.gray200,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.close_rounded,
          color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
          size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 22, desktop: 24),
        ),
      ),
    );
  }

  Widget _buildLanguagesList(BuildContext context, ThemeData theme, bool isDark) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(
          ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
          0,
          ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
          ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
        ),
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final language = _languages[index];
          final isSelected = language['name'] == _selectedLanguage;
          
          return _buildLanguageItem(context, theme, isDark, language, isSelected, index);
        },
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, String> language,
    bool isSelected,
    int index,
  ) {
    final primaryColor = isDark ? AppColors.darkAccentBlue : AppColors.primary;
    
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
      ),
      child: ModernEffects.neumorphism(
        isDark: isDark,
        distance: isSelected ? 2.0 : 4.0,
        intensity: isSelected ? 0.2 : 0.1,
        borderRadius: BorderRadius.circular(16),
        isPressed: isSelected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedLanguage = language['name']!;
              });
              // TODO: تطبيق تغيير اللغة
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
              decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.1),
                        primaryColor.withOpacity(0.05),
                      ],
                    ),
                  )
                : null,
              child: Row(
                children: [
                  Container(
                    width: ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 55, desktop: 60),
                    height: ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 55, desktop: 60),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? primaryColor.withOpacity(0.1)
                        : (isDark ? AppColors.darkElevatedSurface : AppColors.gray50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                          ? primaryColor.withOpacity(0.3)
                          : (isDark ? AppColors.darkDivider : AppColors.gray200),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        language['flag']!,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
                  Expanded(
                    child: Text(
                      language['name']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected 
                          ? primaryColor
                          : (isDark ? AppColors.darkPrimaryText : AppColors.gray800),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
                      decoration: BoxDecoration(
                        gradient: ModernEffects.modernGradient(
                          isDark: isDark,
                          type: GradientType.success,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: ModernEffects.modernShadow(
                          isDark: isDark,
                          type: ShadowType.soft,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 22, desktop: 24),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
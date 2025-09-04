import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class ThemeSelector extends StatefulWidget {
  final Function(String) onThemeSelected;
  
  const ThemeSelector({
    super.key,
    required this.onThemeSelected,
  });

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  String _selectedTheme = 'تلقائي';

  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'تلقائي',
      'icon': Icons.brightness_auto,
      'description': 'يتكيف مع إعدادات النظام',
      'color': AppColors.primary,
    },
    {
      'name': 'فاتح',
      'icon': Icons.light_mode,
      'description': 'المظهر الفاتح',
      'color': AppColors.warning,
    },
    {
      'name': 'داكن',
      'icon': Icons.dark_mode,
      'description': 'المظهر الداكن',
      'color': AppColors.gray800,
    },
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
          _buildThemesList(context, theme, isDark),
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
                type: GradientTypeModern.warning,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: ModernEffects.modernShadow(
                isDark: isDark,
                type: ShadowType.soft,
              ),
            ),
            child: Icon(
              Icons.palette_rounded,
              color: AppColors.white,
              size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          Expanded(
            child: Text(
              'اختر المظهر',
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

  Widget _buildThemesList(BuildContext context, ThemeData theme, bool isDark) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(
          ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
          0,
          ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
          ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
        ),
        itemCount: _themes.length,
        itemBuilder: (context, index) {
          final themeItem = _themes[index];
          final isSelected = themeItem['name'] == _selectedTheme;
          
          return _buildThemeItem(context, theme, isDark, themeItem, isSelected, index);
        },
      ),
    );
  }

  Widget _buildThemeItem(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Map<String, dynamic> themeItem,
    bool isSelected,
    int index,
  ) {
    final themeColor = themeItem['color'] as Color;
    
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: ModernEffects.neumorphism(
        isDark: isDark,
        distance: isSelected ? 2.0 : 4.0,
        intensity: isSelected ? 0.2 : 0.1,
        borderRadius: BorderRadius.circular(20),
        isPressed: isSelected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedTheme = themeItem['name'];
              });
              widget.onThemeSelected(themeItem['name']);
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
              decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: themeColor.withOpacity(0.3),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeColor.withOpacity(0.1),
                        themeColor.withOpacity(0.05),
                      ],
                    ),
                  )
                : null,
              child: Row(
                children: [
                  Container(
                    width: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 65, desktop: 70),
                    height: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 65, desktop: 70),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeColor.withOpacity(0.2),
                          themeColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themeColor.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      themeItem['icon'] as IconData,
                      color: themeColor,
                      size: ResponsiveHelper.getIconSize(context, mobile: 28, tablet: 30, desktop: 32),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          themeItem['name'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 22),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected 
                              ? themeColor
                              : (isDark ? AppColors.darkPrimaryText : AppColors.gray800),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 6, tablet: 8, desktop: 10)),
                        Text(
                          themeItem['description'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                            color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
                      decoration: BoxDecoration(
                        gradient: ModernEffects.modernGradient(
                          isDark: isDark,
                          type: GradientTypeModern.success,
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
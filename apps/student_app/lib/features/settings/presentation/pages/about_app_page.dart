import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/responsive/responsive_widgets.dart';
import '../../../../widgets/modern_design/modern_effects.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage>
    with TickerProviderStateMixin {
  late AnimationController _pageAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _pageAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildAppHeader(theme, isDark),
                  _buildAppDetails(theme, isDark),
                  _buildFeaturesSection(theme, isDark),
                  _buildContactSection(theme, isDark),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBarWidget(
      title: 'عن التطبيق',
      leadingIcon: Icons.arrow_back_ios,
      onLeadingPressed: () => Navigator.pop(context),
      automaticallyImplyLeading: false,
      gradientType: GradientType.primary,
    );
  }

  Widget _buildAppHeader(ThemeData theme, bool isDark) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ModernEffects.glassmorphism(
        isDark: isDark,
        opacity: 0.95,
        blur: 20.0,
        borderOpacity: 0.3,
        borderRadius: BorderRadius.circular(28),
        margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 36, tablet: 40, desktop: 44)),
        child: Container(
          decoration: BoxDecoration(
            gradient: ModernEffects.modernGradient(
              isDark: isDark,
              type: GradientTypeModern.primary,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: ModernEffects.modernShadow(
              isDark: isDark,
              type: ShadowType.glow,
            ),
          ),
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 32, tablet: 36, desktop: 40)),
          child: Column(
            children: [
              Container(
                width: ResponsiveHelper.getIconSize(context, mobile: 90, tablet: 100, desktop: 110),
                height: ResponsiveHelper.getIconSize(context, mobile: 90, tablet: 100, desktop: 110),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.white.withOpacity(0.3),
                      AppColors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: AppColors.white,
                  size: ResponsiveHelper.getIconSize(context, mobile: 45, tablet: 50, desktop: 55),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
              Text(
                'المدرسة الذكية',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                  vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'الإصدار 1.0.0',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                    color: AppColors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
              Text(
                'تمكين الطلاب بأدوات رقمية حديثة لتجربة تعليمية أفضل ونجاح أكاديمي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: AppColors.white.withOpacity(0.9),
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppDetails(ThemeData theme, bool isDark) {
    return ModernEffects.neumorphism(
      isDark: isDark,
      distance: 6.0,
      intensity: 0.1,
      borderRadius: BorderRadius.circular(24),
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات التطبيق',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 24, desktop: 26),
              color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
          _buildDetailItem(
            icon: Icons.person_rounded,
            title: 'المطور',
            value: 'فريق المدرسة الذكية',
            color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
            theme: theme,
            isDark: isDark,
          ),
          _buildDetailItem(
            icon: Icons.email_rounded,
            title: 'البريد الإلكتروني',
            value: 'support@smartschool.com',
            color: isDark ? AppColors.darkSuccess : AppColors.success,
            theme: theme,
            isDark: isDark,
          ),
          _buildDetailItem(
            icon: Icons.web_rounded,
            title: 'الموقع الإلكتروني',
            value: 'www.smartschool.com',
            color: isDark ? AppColors.darkWarning : AppColors.warning,
            theme: theme,
            isDark: isDark,
          ),
          _buildDetailItem(
            icon: Icons.copyright_rounded,
            title: 'حقوق النشر',
            value: '© 2024 المدرسة الذكية. جميع الحقوق محفوظة.',
            color: isDark ? AppColors.darkAccentPurple : AppColors.secondary,
            theme: theme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      child: ModernEffects.neumorphism(
        isDark: isDark,
        distance: 3.0,
        intensity: 0.08,
        borderRadius: BorderRadius.circular(16),
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 6, tablet: 8, desktop: 10)),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                      color: isDark ? AppColors.darkPrimaryText : AppColors.gray800,
                      letterSpacing: 0.3,
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

  Widget _buildFeaturesSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32),
          ),
          child: Text(
            'المميزات الرئيسية',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildFeatureItem(
                icon: Icons.assignment,
                title: 'إدارة الواجبات',
                description: 'إنشاء وتوزيع ومتابعة واجبات الطلاب بسهولة',
                color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                theme: theme,
                isDark: isDark,
              ),
              _buildFeatureItem(
                icon: Icons.people,
                title: 'إدارة الطلاب',
                description: 'إدارة ملفات الطلاب والحضور والتقدم',
                color: isDark ? AppColors.darkSuccess : AppColors.success,
                theme: theme,
                isDark: isDark,
              ),
              _buildFeatureItem(
                icon: Icons.notifications,
                title: 'الإشعارات الذكية',
                description: 'البقاء محدثاً بالإشعارات والتنبيهات في الوقت الفعلي',
                color: isDark ? AppColors.darkWarning : AppColors.warning,
                theme: theme,
                isDark: isDark,
              ),
              _buildFeatureItem(
                icon: Icons.analytics,
                title: 'التحليلات والتقارير',
                description: 'الحصول على رؤى حول أداء الطلاب وإحصائيات الفصل',
                color: isDark ? AppColors.darkAccentPurple : AppColors.secondary,
                theme: theme,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
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
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ThemeData theme, bool isDark) {
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            height: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkWarning.withOpacity(0.2) : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.support_agent,
              color: isDark ? AppColors.darkWarning : AppColors.warning,
              size: ResponsiveHelper.getIconSize(context, mobile: 30, tablet: 35, desktop: 40),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          Text(
            'تواصل معنا',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            'نود أن نسمع منك. تواصل معنا للحصول على الدعم أو الملاحظات أو أي أسئلة.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  icon: Icons.support_agent,
                  title: 'الدعم',
                  color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  onTap: () {
                    // TODO: فتح الدعم
                  },
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
              Expanded(
                child: _buildContactButton(
                  icon: Icons.feedback,
                  title: 'الملاحظات',
                  color: isDark ? AppColors.darkSuccess : AppColors.success,
                  onTap: () {
                    // TODO: فتح الملاحظات
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
          _buildContactButton(
            icon: Icons.bug_report,
            title: 'الإبلاغ عن خطأ',
            color: isDark ? AppColors.darkDestructive : AppColors.error,
            onTap: () {
              // TODO: فتح الإبلاغ عن خطأ
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
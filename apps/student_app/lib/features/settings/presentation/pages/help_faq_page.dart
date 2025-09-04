import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/responsive/responsive_widgets.dart';

class HelpFaqPage extends StatefulWidget {
  const HelpFaqPage({super.key});

  @override
  State<HelpFaqPage> createState() => _HelpFaqPageState();
}

class _HelpFaqPageState extends State<HelpFaqPage>
    with TickerProviderStateMixin {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'كيف أقوم بإنشاء واجب جديد؟',
      answer: 'لإنشاء واجب جديد، اذهب إلى تبويب الواجبات واضغط على زر "+". املأ التفاصيل المطلوبة وأرسل.',
    ),
    FAQItem(
      question: 'كيف يمكنني متابعة حضور الطلاب؟',
      answer: 'يمكنك متابعة الحضور بالذهاب إلى لوحة تحكم الفصل واستخدام ميزة الحضور لتحديد الطلاب الحاضرين/الغائبين.',
    ),
    FAQItem(
      question: 'كيف أقوم بتغيير معلومات ملفي الشخصي؟',
      answer: 'اذهب إلى الإعدادات > الملف الشخصي لتحديث معلوماتك الشخصية وصورة الملف الشخصي وتفاصيل الاتصال.',
    ),
    FAQItem(
      question: 'كيف يمكنني التواصل مع الطلاب؟',
      answer: 'استخدم ميزة الرسائل في تبويب الطلاب لإرسال إعلانات وتذكيرات أو رسائل فردية.',
    ),
    FAQItem(
      question: 'كيف أقوم بجدولة الفصول الدراسية عبر الإنترنت؟',
      answer: 'استخدم قسم الإجراءات السريعة في الصفحة الرئيسية لجدولة اجتماعات Zoom أو جلسات أخرى عبر الإنترنت.',
    ),
  ];

  late AnimationController _pageAnimationController;
  late AnimationController _listAnimationController;
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

    _listAnimationController = AnimationController(
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
      parent: _listAnimationController,
      curve: Curves.elasticOut,
    ));

    _pageAnimationController.forward();
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _listAnimationController.dispose();
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
                  _buildHeader(theme, isDark),
                  _buildSearchBar(theme, isDark),
                  _buildFAQList(theme, isDark),
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
      title: 'المساعدة والأسئلة الشائعة',
      leadingIcon: Icons.arrow_back_ios,
      onLeadingPressed: () => Navigator.pop(context),
      automaticallyImplyLeading: false,
      gradientType: GradientType.primary,
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [
                    AppColors.darkGradientStart,
                    AppColors.darkGradientEnd,
                  ]
                : [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.darkGradientStart : AppColors.primary).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
              height: ResponsiveHelper.getIconSize(context, mobile: 60, tablet: 70, desktop: 80),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.help_outline,
                color: AppColors.white,
                size: ResponsiveHelper.getIconSize(context, mobile: 30, tablet: 35, desktop: 40),
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هل تحتاج للمساعدة؟',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 24),
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8)),
                  Text(
                    'اعثر على إجابات للأسئلة الشائعة واحصل على الدعم',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: AppColors.white.withOpacity(0.9),
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

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.textTheme.bodySmall?.color,
            size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 22, desktop: 24),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
          Expanded(
            child: Text(
              'البحث عن المساعدة...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 28, desktop: 32),
          ),
          child: Text(
            'الأسئلة الشائعة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ..._faqItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildFAQItem(item, index, theme, isDark);
        }).toList(),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem item, int index, ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _listAnimationController.value) * (index + 1)),
          child: Opacity(
            opacity: _listAnimationController.value,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 4, tablet: 6, desktop: 8),
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ExpansionTile(
                leading: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkAccentBlue.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                    size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 22, desktop: 24),
                  ),
                ),
                title: Text(
                  item.question,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
                    child: Text(
                      item.answer,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                iconColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
                collapsedIconColor: theme.textTheme.bodySmall?.color,
              ),
            ),
          ),
        );
      },
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
            'هل ما زلت تحتاج للمساعدة؟',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            'تواصل مع فريق الدعم للحصول على مساعدة شخصية',
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
                  icon: Icons.email,
                  title: 'البريد الإلكتروني',
                  color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                  onTap: () {
                    // TODO: فتح البريد الإلكتروني
                  },
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
              Expanded(
                child: _buildContactButton(
                  icon: Icons.chat,
                  title: 'الدردشة المباشرة',
                  color: isDark ? AppColors.darkSuccess : AppColors.success,
                  onTap: () {
                    // TODO: فتح الدردشة المباشرة
                  },
                ),
              ),
            ],
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

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
} 
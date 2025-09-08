import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/core/responsive/responsive_helper.dart';
import 'package:teacher_app/features/achievements/domain/entities/student.dart';

class StudentCard extends StatefulWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCard({
    Key? key,
    required this.student,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    ));

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  void _startEntryAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _hoverController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _hoverAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        blurRadius: ResponsiveHelper.getCardElevation(context) * 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 2.5),
                    child: Stack(
                      children: [
                        // Background Gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      AppColors.darkAccentBlue.withOpacity(0.1),
                                      AppColors.darkAccentPurple.withOpacity(0.1),
                                    ]
                                  : [
                                      AppColors.info.withOpacity(0.05),
                                      AppColors.primary.withOpacity(0.05),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: ResponsiveHelper.getScreenPadding(context),
                          child: Row(
                            children: [
                              // Avatar with Animation
                              _buildAnimatedAvatar(isDark),
                              const SizedBox(width: 16),

                              // Student Info
                              Expanded(
                                child: _buildStudentInfo(isDark),
                              ),

                              // Action Button
                              _buildActionButton(isDark),
                            ],
                          ),
                        ),

                        // Achievement Badge
                        _buildAchievementBadge(isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAvatar(bool isDark) {
    return Container(
      width: ResponsiveHelper.isMobile(context) ? 70 : 80,
      height: ResponsiveHelper.isMobile(context) ? 70 : 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
              : [AppColors.info, AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.darkAccentBlue.withOpacity(0.3)
                : AppColors.info.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.student.name.isNotEmpty ? widget.student.name[0].toUpperCase() : 'ط',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 22),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.student.name,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'الصف: ${widget.student.classroom}',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 16),
            color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.emoji_events,
              size: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 16),
              color: AppColors.warning,
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.student.unlockedAchievements.length} إنجاز',
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkAccentBlue : AppColors.info,
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkAccentBlue : AppColors.info).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 16),
      ),
    );
  }

  Widget _buildAchievementBadge(bool isDark) {
    final achievementCount = widget.student.unlockedAchievements.length;
    
    if (achievementCount == 0) return const SizedBox.shrink();
    
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '$achievementCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
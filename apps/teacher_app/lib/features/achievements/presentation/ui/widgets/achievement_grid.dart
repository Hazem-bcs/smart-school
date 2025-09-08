import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/core/responsive/responsive_helper.dart';
import 'package:teacher_app/features/achievements/domain/entities/achievement.dart';
import 'achievement_card.dart';

class AchievementGrid extends StatefulWidget {
  final List<Achievement> achievements;
  final String studentId;
  final String studentName;
  final Function(String) onGrantAchievement;
  final Function(String) onRevokeAchievement;

  const AchievementGrid({
    super.key,
    required this.achievements,
    required this.studentId,
    required this.studentName,
    required this.onGrantAchievement,
    required this.onRevokeAchievement,
  });

  @override
  State<AchievementGrid> createState() => _AchievementGridState();
}

class _AchievementGridState extends State<AchievementGrid>
    with TickerProviderStateMixin {
  late AnimationController _gridAnimationController;
  late Animation<double> _gridAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startGridAnimation();
  }

  void _initializeAnimations() {
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _gridAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gridAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startGridAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _gridAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _gridAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _gridAnimation.value)),
          child: Opacity(
            opacity: _gridAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: ResponsiveHelper.getScreenPadding(context),
                  child: _buildHeader(isDark),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Achievements Grid
                Expanded(
                  child: _buildAchievementsGrid(isDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: ResponsiveHelper.getScreenPadding(context),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: ResponsiveHelper.getCardElevation(context) * 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
                    : [AppColors.info, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إنجازات ${widget.studentName}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'يمكنك منح أو إلغاء الإنجازات للطالب',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 16),
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAccentBlue : AppColors.info,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${widget.achievements.where((a) => a.isUnlocked).length}/${widget.achievements.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(bool isDark) {
    if (widget.achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspace_premium_outlined,
              size: 60,
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد إنجازات متاحة',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: ResponsiveHelper.getScreenPadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        mainAxisSpacing: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        crossAxisSpacing: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        childAspectRatio: ResponsiveHelper.getCardAspectRatio(context),
      ),
      itemCount: widget.achievements.length,
      itemBuilder: (context, index) {
        final achievement = widget.achievements[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          child: AchievementCard(
            achievement: achievement,
            onGrant: () => widget.onGrantAchievement(achievement.id),
            onRevoke: () => widget.onRevokeAchievement(achievement.id),
            animationDelay: index * 100,
          ),
        );
      },
    );
  }
}

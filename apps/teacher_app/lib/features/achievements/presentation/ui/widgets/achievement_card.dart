import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/core/responsive/responsive_helper.dart';
import 'package:teacher_app/features/achievements/domain/entities/achievement.dart';

class AchievementCard extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onGrant;
  final VoidCallback onRevoke;
  final int animationDelay;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.onGrant,
    required this.onRevoke,
    this.animationDelay = 0,
  });

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
    if (widget.achievement.isUnlocked) {
      _startPulseAnimation();
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startEntryAnimation() {
    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * (widget.achievement.isUnlocked ? _pulseAnimation.value : 1.0),
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
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
                      // Background
                      _buildBackground(isDark),
                      
                      // Content
                      _buildContent(isDark),
                      
                      // Status Badge
                      _buildStatusBadge(isDark),
                      
                      // Action Button
                      _buildActionButton(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.achievement.isUnlocked
              ? (isDark
                  ? [
                      AppColors.darkSuccess.withOpacity(0.1),
                      AppColors.darkAccentGreen.withOpacity(0.1),
                    ]
                  : [
                      AppColors.success.withOpacity(0.05),
                      AppColors.accentGreen.withOpacity(0.05),
                    ])
              : (isDark
                  ? [
                      AppColors.darkAccentBlue.withOpacity(0.1),
                      AppColors.darkAccentPurple.withOpacity(0.1),
                    ]
                  : [
                      AppColors.info.withOpacity(0.05),
                      AppColors.primary.withOpacity(0.05),
                    ]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          _buildIcon(isDark),
          const SizedBox(height: 8),

          // Title
          Text(
            widget.achievement.title,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Description
          Expanded(
            child: Text(
              widget.achievement.description,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 11, tablet: 12, desktop: 14),
                color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),

          // Points
          _buildPoints(isDark),
        ],
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.achievement.isUnlocked
              ? (isDark
                  ? [AppColors.darkSuccess, AppColors.darkAccentGreen]
                  : [AppColors.success, AppColors.accentGreen])
              : (isDark
                  ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
                  : [AppColors.info, AppColors.primary]),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (widget.achievement.isUnlocked
                    ? (isDark ? AppColors.darkSuccess : AppColors.success)
                    : (isDark ? AppColors.darkAccentBlue : AppColors.info))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        _getAchievementIcon(),
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildPoints(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: widget.achievement.isUnlocked
            ? (isDark ? AppColors.darkSuccess : AppColors.success)
            : (isDark ? AppColors.darkAccentBlue : AppColors.info),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars,
            color: Colors.white,
            size: 10,
          ),
          const SizedBox(width: 3),
          Text(
            '${widget.achievement.points}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: widget.achievement.isUnlocked
              ? (isDark ? AppColors.darkSuccess : AppColors.success)
              : (isDark ? AppColors.darkSecondaryText : AppColors.gray600),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.achievement.isUnlocked ? Icons.check_circle : Icons.lock,
              color: Colors.white,
              size: 8,
            ),
            const SizedBox(width: 2),
            Text(
              widget.achievement.isUnlocked ? 'مُمنح' : 'غير مُمنح',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isDark) {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.achievement.isUnlocked
                ? (isDark
                    ? [AppColors.darkDestructive, AppColors.darkError]
                    : [AppColors.error, AppColors.destructive])
                : (isDark
                    ? [AppColors.darkSuccess, AppColors.darkAccentGreen]
                    : [AppColors.success, AppColors.accentGreen]),
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: (widget.achievement.isUnlocked
                      ? (isDark ? AppColors.darkDestructive : AppColors.error)
                      : (isDark ? AppColors.darkSuccess : AppColors.success))
                  .withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: widget.achievement.isUnlocked ? widget.onRevoke : widget.onGrant,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.achievement.isUnlocked ? Icons.remove_circle : Icons.add_circle,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    widget.achievement.isUnlocked ? 'إلغاء' : 'منح',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
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

  IconData _getAchievementIcon() {
    switch (widget.achievement.id) {
      case '1':
        return Icons.school;
      case '2':
        return Icons.event_available;
      case '3':
        return Icons.emoji_events;
      case '4':
        return Icons.menu_book;
      case '5':
        return Icons.group;
      case '6':
        return Icons.leaderboard;
      default:
        return Icons.workspace_premium;
    }
  }
}

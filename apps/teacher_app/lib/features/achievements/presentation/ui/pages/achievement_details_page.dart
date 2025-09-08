import 'package:flutter/material.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/features/achievements/domain/entities/achievement.dart';

class AchievementDetailsPage extends StatefulWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final VoidCallback? onGrant;
  final VoidCallback? onRevoke;

  const AchievementDetailsPage({
    super.key,
    required this.achievement,
    required this.isUnlocked,
    this.onGrant,
    this.onRevoke,
  });

  @override
  State<AchievementDetailsPage> createState() => _AchievementDetailsPageState();
}

class _AchievementDetailsPageState extends State<AchievementDetailsPage>
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
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
      begin: 50.0,
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

  void _startAnimations() {
    _animationController.forward();
    if (widget.isUnlocked) {
      _pulseController.repeat(reverse: true);
    }
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

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isUnlocked
                    ? (isDark
                        ? [AppColors.darkSuccess, AppColors.darkAccentGreen]
                        : [AppColors.success, AppColors.accentGreen])
                    : (isDark
                        ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
                        : [AppColors.info, AppColors.primary]),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([_animationController, _pulseController]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value * (widget.isUnlocked ? _pulseAnimation.value : 1.0),
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(isDark),
                          
                          // Achievement Details
                          Expanded(
                            child: _buildAchievementDetails(isDark),
                          ),
                          
                          // Action Button
                          _buildActionButton(isDark),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تفاصيل الإنجاز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.isUnlocked ? 'تم منح هذا الإنجاز' : 'إنجاز متاح للمنح',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementDetails(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Achievement Icon
          _buildAchievementIcon(isDark),
          const SizedBox(height: 32),

          // Achievement Info
          _buildAchievementInfo(isDark),
          const SizedBox(height: 32),

          // Status Card
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildAchievementIcon(bool isDark) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: widget.isUnlocked
              ? (isDark
                  ? [AppColors.darkSuccess, AppColors.darkAccentGreen]
                  : [AppColors.success, AppColors.accentGreen])
              : (isDark
                  ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
                  : [AppColors.info, AppColors.primary]),
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isUnlocked
                    ? (isDark ? AppColors.darkSuccess : AppColors.success)
                    : (isDark ? AppColors.darkAccentBlue : AppColors.info))
                .withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Icon(
        _getAchievementIcon(),
        color: Colors.white,
        size: 80,
      ),
    );
  }

  Widget _buildAchievementInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.achievement.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            widget.achievement.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stars,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.achievement.points} نقطة',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.isUnlocked ? Icons.check_circle : Icons.lock,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isUnlocked ? 'تم منح الإنجاز' : 'إنجاز غير مُمنح',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isUnlocked
                      ? 'تم منح هذا الإنجاز للطالب بنجاح'
                      : 'يمكنك منح هذا الإنجاز للطالب',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isUnlocked
                ? (isDark
                    ? [AppColors.darkDestructive, AppColors.darkError]
                    : [AppColors.error, AppColors.destructive])
                : (isDark
                    ? [AppColors.darkSuccess, AppColors.darkAccentGreen]
                    : [AppColors.success, AppColors.accentGreen]),
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (widget.isUnlocked
                      ? (isDark ? AppColors.darkDestructive : AppColors.error)
                      : (isDark ? AppColors.darkSuccess : AppColors.success))
                  .withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.isUnlocked ? widget.onRevoke : widget.onGrant,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isUnlocked ? Icons.remove_circle : Icons.add_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isUnlocked ? 'إلغاء الإنجاز' : 'منح الإنجاز',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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

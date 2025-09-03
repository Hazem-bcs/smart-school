import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for displaying individual notification card
class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = _getCardColor(isDark);
    final iconColor = _getIconColor(isDark);
    final iconBackgroundColor = _getIconBackgroundColor(isDark);
    final titleColor = _getTitleColor(isDark);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      elevation: notification.isRead ? AppSpacing.xsElevation : AppSpacing.smElevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.mdBorderRadius,
      ),
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.mdBorderRadius,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark, iconColor, iconBackgroundColor, titleColor),
              if (notification.imageUrl != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildImage(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    Color iconColor,
    Color iconBackgroundColor,
    Color titleColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIcon(iconColor, iconBackgroundColor),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: _buildContent(isDark, titleColor),
        ),
      ],
    );
  }

  Widget _buildIcon(Color iconColor, Color iconBackgroundColor) {
    return CircleAvatar(
      backgroundColor: iconBackgroundColor,
      child: Icon(
        notification.isRead
            ? Icons.notifications_none
            : Icons.notifications_active,
        color: iconColor,
        size: AppSpacing.mdIcon,
      ),
    );
  }

  Widget _buildContent(bool isDark, Color titleColor) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.bold,
              color: titleColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            notification.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _getBodyColor(isDark),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTimestamp(isDark),
        ],
      ),
    );
  }

  Widget _buildTimestamp(bool isDark) {
    return Builder(
      builder: (context) => Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          DateFormat('MMM dd, yyyy - hh:mm a')
              .format(notification.sentTime),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return ClipRRect(
      borderRadius: AppSpacing.smBorderRadius,
      child: Image.network(
        notification.imageUrl!,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 150,
          width: double.infinity,
          color: isDark ? AppColors.darkDivider : AppColors.gray200,
          child: Icon(
            Icons.broken_image,
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
            size: AppSpacing.xl2Icon,
          ),
        ),
      ),
    );
  }

  // ==================== COLOR GETTERS ====================

  Color _getCardColor(bool isDark) {
    if (notification.isRead) {
      return isDark 
          ? AppColors.darkCardBackground.withOpacity(0.5) 
          : AppColors.white;
    }
    return isDark 
        ? AppColors.darkCardBackground 
        : AppColors.gray50;
  }

  Color _getIconColor(bool isDark) {
    if (notification.isRead) {
      return isDark 
          ? AppColors.darkSecondaryText 
          : AppColors.gray400;
    }
    return isDark 
        ? AppColors.darkAccentBlue 
        : AppColors.primary;
  }

  Color _getIconBackgroundColor(bool isDark) {
    if (notification.isRead) {
      return isDark 
          ? AppColors.darkElevatedSurface 
          : AppColors.gray100;
    }
    final baseColor = isDark 
        ? AppColors.darkAccentBlue 
        : AppColors.primary;
    return baseColor.withOpacity(0.1);
  }

  Color _getTitleColor(bool isDark) {
    if (notification.isRead) {
      return isDark 
          ? AppColors.darkSecondaryText 
          : AppColors.gray600;
    }
    return isDark 
        ? AppColors.darkPrimaryText 
        : AppColors.gray800;
  }

  Color _getBodyColor(bool isDark) {
    if (notification.isRead) {
      return isDark 
          ? AppColors.darkSecondaryText 
          : AppColors.gray500;
    }
    return isDark 
        ? AppColors.darkPrimaryText 
        : AppColors.gray700;
  }
}
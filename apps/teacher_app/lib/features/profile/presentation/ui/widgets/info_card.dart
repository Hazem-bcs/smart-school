import 'package:flutter/material.dart';
import '../../theme/profile_theme.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<InfoCardItem> items;
  final int animationDelay;

  const InfoCard({
    super.key,
    required this.title,
    required this.items,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ProfileTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: ProfileTheme.title,
            ),
            const SizedBox(height: 16),
            
            // Items
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < items.length - 1 ? 12 : 0),
                child: _buildInfoItem(item),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(InfoCardItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ProfileTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconData(item.icon),
                color: ProfileTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.primaryText,
                    style: ProfileTheme.body,
                  ),
                  if (item.secondaryText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.secondaryText!,
                      style: ProfileTheme.caption,
                    ),
                  ],
                ],
              ),
            ),
            
            // Action indicator
            if (item.onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: ProfileTheme.textSecondary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'twitter':
        return Icons.flutter_dash; // Using flutter_dash as Twitter alternative
      case 'linkedin':
        return Icons.work;
      case 'book_open':
        return Icons.book;
      case 'users':
        return Icons.people;
      case 'building':
        return Icons.business;
      case 'graduation_cap':
        return Icons.school;
      case 'certificate':
        return Icons.verified;
      default:
        return Icons.info;
    }
  }
}

class InfoCardItem {
  final String icon;
  final String primaryText;
  final String? secondaryText;
  final VoidCallback? onTap;

  InfoCardItem({
    required this.icon,
    required this.primaryText,
    this.secondaryText,
    this.onTap,
  });
} 
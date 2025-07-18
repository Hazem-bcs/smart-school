import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = isDestructive 
        ? const Color(0xFFEF4444) 
        : const Color(0xFF6366F1);
    
    final defaultTitleColor = isDestructive 
        ? const Color(0xFFEF4444) 
        : const Color(0xFF1E293B);
    
    final defaultSubtitleColor = const Color(0xFF64748B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // الأيقونة
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? defaultIconColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? defaultIconColor,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? defaultTitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor ?? defaultSubtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // عنصر التحكم
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF6366F1),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى القسم
          Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
} 
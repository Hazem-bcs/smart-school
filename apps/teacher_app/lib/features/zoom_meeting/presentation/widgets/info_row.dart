import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isUrl;
  final VoidCallback? onTap;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.isUrl = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: isUrl
              ? InkWell(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
        ),
      ],
    );
  }
} 
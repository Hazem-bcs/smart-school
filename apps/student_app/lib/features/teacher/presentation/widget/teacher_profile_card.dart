import 'package:flutter/material.dart';
import 'package:smart_school/widgets/app_exports.dart';

class TeacherProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subject;
  final Function() onTap;

  const TeacherProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    final colors = _gradientFor(name);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -18,
              right: -18,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -14,
              left: -14,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  AppAvatarWidget(imageUrl: imageUrl, radius: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book, color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                subject,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _gradientFor(String name) {
    final palettes = <List<Color>>[
      [const Color(0xFF7B61FF), const Color(0xFF5E2EFF)],
      [const Color(0xFF00C6FF), const Color(0xFF0072FF)],
      [const Color(0xFFFF6CAB), const Color(0xFF7366FF)],
      [const Color(0xFFFFA726), const Color(0xFFFF7043)],
      [const Color(0xFF42E695), const Color(0xFF3BB2B8)],
    ];
    final index = name.hashCode.abs() % palettes.length;
    return palettes[index];
  }
}

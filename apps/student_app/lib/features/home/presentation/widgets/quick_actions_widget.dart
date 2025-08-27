import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/quick_action_entity.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<QuickActionEntity> actions;

  const QuickActionsWidget({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              'إجراءات سريعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionCard(context, action, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, QuickActionEntity action, int index) {
    // ألوان متنوعة لكل إجراء
    final List<Color> colors = [
      const Color(0xFF4F46E5), // أزرق
      const Color(0xFF10B981), // أخضر
      const Color(0xFFF59E0B), // برتقالي
      const Color(0xFFEF4444), // أحمر
    ];
    
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(action.route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      action.iconPath,
                      width: 24,
                      height: 24,
                      color: color,
                    ),
                  ),
                  if (action.count > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          action.count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                action.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                action.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

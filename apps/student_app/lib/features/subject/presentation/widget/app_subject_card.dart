import 'package:core/domain/entities/subject_entity.dart';
import '../../../../widgets/app_exports.dart';

class AppSubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  final VoidCallback? onTap;

  const AppSubjectCard({
    Key? key,
    required this.subject,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradientFor(subject.name),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // زخارف خلفية بسيطة
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -15,
                left: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // المحتوى
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book, color: Colors.white, size: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subject.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _pill(icon: Icons.school, label: subject.grade),
                        _pill(icon: Icons.class_, label: subject.classroom),
                      ],
                    ),
                    if ((subject.teacher ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, color: Colors.white70, size: 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              subject.teacher!,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _gradientFor(String name) {
    final palettes = <List<Color>>[
      [const Color(0xFF7B61FF), const Color(0xFF5E2EFF)], // بنفسجي
      [const Color(0xFF00C6FF), const Color(0xFF0072FF)], // أزرق
      [const Color(0xFFFF6CAB), const Color(0xFF7366FF)], // وردي-بنفسجي
      [const Color(0xFFFFA726), const Color(0xFFFF7043)], // برتقالي
      [const Color(0xFF42E695), const Color(0xFF3BB2B8)], // أخضر-فيروزي
    ];
    final index = name.hashCode.abs() % palettes.length;
    return palettes[index];
  }

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
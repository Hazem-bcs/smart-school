import 'package:core/domain/entities/subject_entity.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/features/subject/presentation/pages/subjects_page.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';

class SubjectDetailsPage extends StatelessWidget {
  final int subjectId;

  const SubjectDetailsPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    final SubjectEntity? subject = dummySubjects.firstWhere(
      (s) => s.id == subjectId,
      orElse:
          () =>
              null as SubjectEntity, // لإرجاع null إذا لم يتم العثور على المادة
    );

    if (subject == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('المادة غير موجودة!')),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(title: subject.name),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'subject-image-${subject.id}',
              child: Image.network(
                subject.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.book,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'هذه المادة تعتبر أساسية لفهم المفاهيم العلمية المتقدمة وتطوير مهارات التفكير النقدي.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsCard(
                    context,
                    title: 'ماذا ستتعلم؟',
                    content:
                        '• فهم أساسيات ...\n• تطبيق مفاهيم ...\n• تحليل بيانات ...',
                    icon: Icons.lightbulb_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsCard(
                    context,
                    title: 'المدرسين المتاحين',
                    content: '• أ. أحمد محمود\n• د. سارة فؤاد',
                    icon: Icons.people_alt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Text(
              content,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

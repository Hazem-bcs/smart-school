//
// import 'package:core/domain/entities/subject_entity.dart';
//
// import '../../../../widgets/app_exports.dart';
//
// class AppSubjectCard extends StatelessWidget {
//   final SubjectEntity subject;
//   final VoidCallback? onTap;
//
//   const AppSubjectCard({
//     Key? key,
//     required this.subject,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               flex: 3,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//                 child: Image.network(
//                   subject.image,
//                   fit: BoxFit.cover,
//                   width: 50,
//                   height: 50,
//                   errorBuilder: (context, error, stackTrace) =>
//                   const Icon(
//                     Icons.book,
//                     size: 80,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text(
//                     subject.name,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 💡 التعديل هنا: تحديد ارتفاع ثابت للصورة بدلاً من Expanded
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                subject.image,
                fit: BoxFit.cover,
                // يمكنك تعديل هذا الارتفاع ليتناسب مع تصميمك في الـ Grid
                height: 120, // 👈 مثال: ارتفاع ثابت للصورة
                width: double.infinity, // تأكد أنها تأخذ العرض المتاح بالكامل
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox( // استخدم SizedBox مع حجم ثابت بدلاً من Icon كبير
                  height: 120, // نفس ارتفاع الصورة
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      Icons.book,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // 💡 التعديل هنا: استخدام SizedBox أو Container بارتفاع ثابت للنص
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox( // 👈 مثال: ارتفاع ثابت لودجت النص
                height: 40, // يمكنك تعديل هذا الارتفاع
                child: Center(
                  child: Text(
                    subject.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
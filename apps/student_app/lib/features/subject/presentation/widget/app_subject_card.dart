// import 'package:smart_school/widgets/app_exports.dart';
//
// class AppSubjectCard extends StatelessWidget {
//   final String imageUrl;
//   final String nameSubject;
//   final String level;
//   final double width;
//   final double height;
//   final Function() onTap;
//
//   const AppSubjectCard({
//     super.key,
//     this.imageUrl = "assets/images/Applcon.png",
//     required this.nameSubject,
//     this.width = 150,
//     this.height = 180,
//     required this.onTap,
//     required this.level,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: width,
//         height: height,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           border: Border.all(color: tertiaryColor, width: 1.5),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AppAvatarWidget(imageUrl: imageUrl, radius: 50),
//             const SizedBox(height: 12),
//             Text(
//               nameSubject,
//               style: const TextStyle(fontSize: 18, ),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               level,
//               style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
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
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  subject.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(
                    Icons.book,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
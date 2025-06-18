import 'package:smart_school/widgets/app_exports.dart';

class TeacherProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double width;
  final double height;
  final Function() onTap;

  const TeacherProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.width = 150,
    this.height = 180,
   required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: tertiaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAvatarWidget(imageUrl: imageUrl, radius: 50),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

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
        margin: const EdgeInsets.all(8),
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all( color: tertiaryColor,width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAvatarWidget(imageUrl: imageUrl, radius: 50),
            const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
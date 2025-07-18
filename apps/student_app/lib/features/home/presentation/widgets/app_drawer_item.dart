import 'package:flutter_svg/svg.dart';
import 'package:smart_school/widgets/app_exports.dart';

class DrawerItem extends StatelessWidget {
  final VoidCallback onTap;
  final String? imageUrl;
  final String title;
  final IconData? icon;

  const DrawerItem({
    required this.onTap,
    this.imageUrl,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              imageUrl ?? "assets/svg/fee.svg",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 20),
            AppTextWidget(text: title),
          ],
        ),
      ),
    );
  }
}

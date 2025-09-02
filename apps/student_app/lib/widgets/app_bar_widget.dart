import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/theme/index.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return AppBar(
      automaticallyImplyLeading: true,
      toolbarHeight: 100,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: AppTextStyle.appBarTitle(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      // backgroundColor: primaryColor,
      backgroundColor: AppColors.primary,
      centerTitle: true,
      leading:
          hasDrawer
              ? Builder(
                builder:
                    (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
              )
              : (canPop ? BackButton(color: Colors.white) : null),
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

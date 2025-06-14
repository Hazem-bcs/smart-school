import 'package:flutter/material.dart';
class AppBottomSheet<T> extends StatelessWidget {
  const AppBottomSheet._({
    Key? key,
    required this.child,
  }) : super(key: key);


  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required final Widget child,
     final bool? enableDrag,
     final bool? isDismissible,
     final bool? isScrollControlled,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        enableDrag: enableDrag ?? true,
        isDismissible: isDismissible ?? true,
        isScrollControlled: isScrollControlled ?? true,
        barrierColor: Colors.black.withOpacity(0.2),
        backgroundColor: Colors.white,
        builder: (_) => AppBottomSheet._(child: child),
      );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import 'app_icon_widget.dart';

class AppImageWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit boxFit;

  AppImageWidget({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isAssets = path.toLowerCase().startsWith("assets");

    final isNetwork = path.toLowerCase().startsWith("http");

    final isFile = !isAssets && !isNetwork;

    // if (isNetwork) {
    //   return CachedNetworkImage(
    //     imageUrl: path,
    //     width: width,
    //     height: height,
    //     fit: boxFit,
    //     placeholder: (
    //         BuildContext context,
    //         String url,
    //         ) {
    //       return const Center(
    //         child: CircularProgressIndicator(
    //           color: Colors.grey,
    //         ),
    //       );
    //     },
    //     errorWidget: (
    //         BuildContext context,
    //         String url,
    //         Object error,
    //         ) {
    //       return Center(
    //         child: AppIconWidget(
    //           icon: Icons.error,
    //           color: Colors.red,
    //         ),
    //       );
    //     },
    //   );
    // }
    if (isAssets) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: boxFit,
      );
    }
    if (isFile) {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: boxFit,
      );
    }

    return const Placeholder();
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoadingWidget extends StatefulWidget {
  final double size;

  const AppLoadingWidget({super.key, this.size = 60.0});

  @override
  State<AppLoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<AppLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child:
      Platform.isAndroid
          ? CircularProgressIndicator(color: Colors.blue)
          : CupertinoActivityIndicator(color: Colors.blue),
    );
  }
}

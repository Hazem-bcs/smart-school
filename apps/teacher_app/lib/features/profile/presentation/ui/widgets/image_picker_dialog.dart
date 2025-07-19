import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;

  const ImagePickerDialog({
    super.key,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Image Source'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.of(context).pop();
              onSourceSelected(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.of(context).pop();
              onSourceSelected(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, Function(ImageSource) onSourceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerDialog(onSourceSelected: onSourceSelected);
      },
    );
  }
} 
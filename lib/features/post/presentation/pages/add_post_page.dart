import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_school/theme/constants/colors.dart';
import 'package:smart_school/widgets/app_circle_button_widget.dart';
import 'package:smart_school/widgets/app_round_button_widget.dart';

import '../../../../widgets/app_avatar_widget.dart';
import '../../../../widgets/app_text_button_widget.dart';
import '../../../../widgets/app_text_field_widget.dart';
import '../../../../widgets/app_text_widget.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File? _selectImage;
  final TextEditingController _textController = TextEditingController();

  _AddPostPageState();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      setState(() {
        _selectImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "create post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppAvatarWidget(imageUrl: "imageUrl", radius: 25),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(
                        text: "  userName",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppTextButtonWidget(
                            iconButton: Icons.public,
                            label: "public ",
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppTextFieldWidget(controller: _textController, hint: "بم تفكر"),
              if (_selectImage != null)
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Image.file(
                          _selectImage!,
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: AppCircleButtonWidget(
                        iconData: Icons.close,
                        onPressed: () {
                          setState(() {
                            _selectImage = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),

              // const Spacer(),
              const SizedBox(height: 50),
              _buildOption(
                Icons.image,
                "photo/video",
                _pickImage,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 10),
              _buildOption(
                Icons.camera,
                "camera",
                _pickImageFromCamera,
                iconColor: Colors.red,
              ),
              const SizedBox(height: 10),

              Center(
                child: AppRoundButtonWidget(
                  title: 'post',
                  onPress: () {
                    FocusScope.of(context).unfocus();
                  },
                  backGroundColor: primaryColor,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildOption(
  IconData icon,
  String label,
  VoidCallback onTap, {
  Color iconColor = Colors.grey,
  double textSize = 15,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30, color: iconColor),
        const SizedBox(width:8 ),
        Flexible(child: Text(label, style: TextStyle(fontSize: textSize),),),
      ],
    ),
  );
}

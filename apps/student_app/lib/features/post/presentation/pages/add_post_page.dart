import 'package:core/theme/constants/app_strings.dart';
import 'package:core/theme/constants/colors.dart';
import 'package:core/widgets/app_exports.dart';

import '../../../../widgets/app_exports.dart';
class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File? _selectImage;
  final TextEditingController _textController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectImage = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() => _selectImage = File(pickedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Add Post", style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body:Stack(
        children: [
          AppBarImageWidget(
            isImage: true,
            title: "Add your post",
            height: 200,
            imageName: 'assets/images/homework.png',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 200 + 16,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppAvatarWidget(imageUrl: "imageUrl", radius: 25),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(
                            text: "userName",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          AppTextButtonWidget(
                            iconButton: Icons.public,
                            label: "Public",
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppTextFieldWidget(controller: _textController, hint: "بم تفكر؟"),
                  if (_selectImage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        children: [
                          Image.file(
                            _selectImage!,
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: AppCircleButtonWidget(
                              iconData: Icons.close,
                              onPressed: () => setState(() => _selectImage = null),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildOption(Icons.image, "Photo/Video", _pickImage, iconColor: Colors.green),
                  const SizedBox(height: 10),
                  _buildOption(Icons.camera, "Camera", _pickImageFromCamera, iconColor: Colors.red),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: AppRoundButtonWidget(
              title: AppStrings.post,
              onPress: () => FocusScope.of(context).unfocus(),
              backGroundColor: primaryColor,
              textColor: Colors.white,
            ),
          ),
        ],
      )

    );
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
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 8),
          Flexible(child: Text(label, style: TextStyle(fontSize: textSize))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_text_form_field.dart';

class NewAssignmentTitleField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final String? Function(String?)? validator;
  const NewAssignmentTitleField({super.key, required this.controller, required this.isDark, this.validator});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: 'العنوان',
      placeholder: 'عنوان الواجب',
      controller: controller,
      validator: validator,
    );
  }
} 
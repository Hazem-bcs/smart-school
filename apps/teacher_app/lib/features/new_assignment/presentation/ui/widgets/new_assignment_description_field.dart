import 'package:flutter/material.dart';
import '../widgets/custom_text_form_field.dart';

class NewAssignmentDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final String? Function(String?)? validator;
  const NewAssignmentDescriptionField({super.key, required this.controller, required this.isDark, this.validator});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: 'Description',
      placeholder: 'Assignment Description',
      controller: controller,
      maxLines: 5,
      validator: validator,
    );
  }
} 
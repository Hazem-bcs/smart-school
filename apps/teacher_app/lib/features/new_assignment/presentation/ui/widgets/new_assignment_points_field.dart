import 'package:flutter/material.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/section_title.dart';
import 'package:flutter/services.dart';

class NewAssignmentPointsField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final String? Function(String?)? validator;
  const NewAssignmentPointsField({super.key, required this.controller, required this.isDark, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'الدرجة القصوى', icon: Icons.star, iconColor: isDark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary),
        CustomTextFormField(
          label: 'الدرجات',
          placeholder: 'مثال: 100',
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: validator,
        ),
      ],
    );
  }
} 
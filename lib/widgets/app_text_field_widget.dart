// import 'package:flutter/material.dart';
// import 'package:smart_school/theme/colors.dart';
//
// import '../theme/colors.dart';
//
// class AppTextFieldWidget extends StatelessWidget {
//   final String? hint;
//   final String? label;
//   final TextEditingController? textController;
//
//   const AppTextFieldWidget({
//     Key? key,
//     this.hint,
//     this.textController,
//     this.label,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: textController,
//       decoration: InputDecoration(
//         filled: true,
//         // label:Text(label!),
//         hintStyle: TextStyle(color: primaryColor),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: primaryColor),
//           borderRadius: BorderRadius.circular(30),
//         ),
//
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//         hintText: hint,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:smart_school/theme/constants/colors.dart';

class AppTextFieldWidget extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;

  const AppTextFieldWidget({
    Key? key,
    this.hint,
    this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: secondaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
    );
  }
}

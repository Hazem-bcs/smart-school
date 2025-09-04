import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';

class VerificationNumberFieldsWidget extends StatefulWidget {
  const VerificationNumberFieldsWidget({
    super.key,
    required this.onCompleted,
    this.validator,
    required this.onChanged,
  });

  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<VerificationNumberFieldsWidget> createState() => _VerificationNumberFieldsWidgetState();
}

class _VerificationNumberFieldsWidgetState extends State<VerificationNumberFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: min(60, size.width / 6),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.mdBorderRadius,
        color: isDark ? AppColors.darkElevatedSurface : AppColors.gray400,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: AppSpacing.mdBorderRadius,
      color: isDark ? AppColors.darkAccentBlue.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
      border: Border.all(
        color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
        width: 2,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        validator: widget.validator,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        pinAnimationType: PinAnimationType.slide,
        onCompleted: widget.onCompleted,
        onChanged: widget.onChanged,
        length: 6,
        inputFormatters: [],
      ),
    );
  }
}

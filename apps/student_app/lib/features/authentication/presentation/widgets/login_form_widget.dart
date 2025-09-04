import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';

/// Widget for login form with theme support
class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? onEmailValidation;
  final String? Function(String?)? onPasswordValidation;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.onEmailValidation,
    this.onPasswordValidation,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: AppSpacing.xlPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.white,
        borderRadius: AppSpacing.lgBorderRadius,
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? AppColors.black.withOpacity(0.3)
              : AppColors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            // Email Field
            _buildTextField(
              controller: widget.emailController,
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الإلكتروني',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: widget.onEmailValidation ?? _validateEmail,
              isDark: isDark,
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Password Field
            _buildTextField(
              controller: widget.passwordController,
              label: 'كلمة المرور',
              hint: 'أدخل كلمة المرور',
              icon: Icons.lock_outlined,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                ),
              ),
              validator: widget.onPasswordValidation ?? _validatePassword,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTextStyles.bodyLarge.copyWith(
        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
          size: 22,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark 
          ? AppColors.darkElevatedSurface 
          : AppColors.gray50,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.mdBorderRadius,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.gray300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.mdBorderRadius,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.gray300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.mdBorderRadius,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.mdBorderRadius,
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.mdBorderRadius,
          borderSide: BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
          fontSize: 16,
        ),
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: isDark ? AppColors.darkSecondaryText.withOpacity(0.6) : AppColors.gray400,
          fontSize: 14,
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:core/theme/constants/app_colors.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'profile_image_section.dart';
import 'custom_text_field.dart';
import 'action_buttons.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isDark;
  final File? selectedImage;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final bool isLoading;
  final VoidCallback onImageTap;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.isDark,
    required this.selectedImage,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.bioController,
    required this.isLoading,
    required this.onImageTap,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkBackground,
            AppColors.darkBackground.withOpacity(0.95),
          ],
        ),
      ) : null,
      child: ResponsiveContent(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
              vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
            ),
            children: [
              ProfileImageSection(
                isDark: isDark,
                selectedImage: selectedImage,
                onImageTap: onImageTap,
              ),
              CustomTextField(
                controller: nameController,
                labelText: 'الاسم الكامل',
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الاسم مطلوب';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: emailController,
                labelText: 'البريد الإلكتروني',
                isDark: isDark,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'البريد الإلكتروني مطلوب';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'يرجى إدخال بريد إلكتروني صالح';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: phoneController,
                labelText: 'رقم الجوال',
                isDark: isDark,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'رقم الجوال مطلوب';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: bioController,
                labelText: 'نبذة تعريفية',
                isDark: isDark,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'النبذة مطلوبة';
                  }
                  return null;
                },
              ),
              ActionButtons(
                isDark: isDark,
                isLoading: isLoading,
                onSave: onSave,
                onCancel: onCancel,
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
            ],
          ),
        ),
      ),
    );
  }
} 
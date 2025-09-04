import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_text_styles.dart';
import 'package:core/theme/constants/app_spacing.dart';
import '../../../../widgets/app_exports.dart';


class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  File? _pickedImageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.currentUser.name ?? '');
    _emailController = TextEditingController(text: widget.currentUser.email);
    _phoneController = TextEditingController(text: widget.currentUser.phone ?? '');
    _addressController = TextEditingController(text: widget.currentUser.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      _showSuccessMessage();
      Navigator.of(context).pop();
    }
  }

  void _showSuccessMessage() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ التغييرات بنجاح',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSuccess : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.baseBorderRadius,
        ),
        margin: AppSpacing.baseMargin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildAppBar(theme, isDark),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              _buildProfilePictureSection(theme, isDark),
              const SizedBox(height: AppSpacing.xl),
              _buildFormFields(theme, isDark),
              const SizedBox(height: AppSpacing.xl),
              _buildSaveButton(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      title: Text(
        'تعديل الملف الشخصي',
        style: AppTextStyles.h4.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isDark ? AppColors.darkGradientStart : AppColors.primary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: isDark ? AppColors.darkCardBackground : AppColors.white,
                  backgroundImage: _pickedImageFile != null
                      ? FileImage(_pickedImageFile!) as ImageProvider
                      : (widget.currentUser.profilePhotoUrl != null
                      ? NetworkImage(widget.currentUser.profilePhotoUrl!)
                      : const AssetImage("assets/images/user_3.png") as ImageProvider),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: AppSpacing.smPadding,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'اضغط على الكاميرا لتغيير الصورة',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(ThemeData theme, bool isDark) {
    return Column(
      children: [
        _buildTextField(
          theme: theme,
          isDark: isDark,
          controller: _nameController,
          label: 'الاسم الكامل',
          hint: 'أدخل اسمك الكامل',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال الاسم';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        _buildTextField(
          theme: theme,
          isDark: isDark,
          controller: _emailController,
          label: 'البريد الإلكتروني',
          hint: 'أدخل بريدك الإلكتروني',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            if (!value.contains('@')) {
              return 'يرجى إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        _buildTextField(
          theme: theme,
          isDark: isDark,
          controller: _phoneController,
          label: 'رقم الهاتف',
          hint: 'أدخل رقم هاتفك',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.lg),

        _buildTextField(
          theme: theme,
          isDark: isDark,
          controller: _addressController,
          label: 'العنوان',
          hint: 'أدخل عنوانك',
          icon: Icons.location_on,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required ThemeData theme,
    required bool isDark,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
        borderRadius: AppSpacing.baseBorderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.darkPrimaryText : AppColors.gray900,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.labelMedium.copyWith(
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
          ),
          hintText: hint,
          hintStyle: AppTextStyles.labelSmall.copyWith(
            color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
          ),
          prefixIcon: Container(
            margin: AppSpacing.smMargin,
            padding: AppSpacing.smPadding,
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.1),
              borderRadius: AppSpacing.smBorderRadius,
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: AppSpacing.baseBorderRadius,
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
            : [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: AppSpacing.baseBorderRadius,
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkAccentBlue : AppColors.primary).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _saveChanges,
        icon: _isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: AppColors.white,
            strokeWidth: 2,
          ),
        )
            : Icon(
                Icons.save,
                color: AppColors.white,
                                 size: 24,
              ),
        label: Text(
          _isLoading ? 'جاري الحفظ...' : 'حفظ التغييرات',
          style: AppTextStyles.buttonPrimary.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.baseBorderRadius,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Form data
  String? _selectedSubject;
  bool _isLoading = false;

  // Available subjects
  final List<String> _availableSubjects = [
    'Mathematics',
    'Science',
    'English',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'Art',
    'Music',
    'Physical Education',
  ];

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _pageAnimationController.forward();

    // Initialize with sample data
    _nameController.text = 'Teacher Name';
    _emailController.text = 'teacher@school.com';
    _phoneController.text = '+1234567890';
    _bioController.text = 'Experienced teacher with 5+ years in education.';
    _selectedSubject = 'Mathematics';
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme, isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
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
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                    vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
                  ),
                  children: [
                    _buildProfileImageSection(isDark),
                    _buildNameField(isDark),
                    _buildEmailField(isDark),
                    _buildPhoneField(isDark),
                    _buildSubjectField(isDark),
                    _buildBioField(isDark),
                    _buildActionButtons(isDark),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkGradientStart : theme.appBarTheme.backgroundColor,
      elevation: 0,
      flexibleSpace: isDark ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkGradientStart,
              AppColors.darkGradientEnd,
            ],
          ),
        ),
      ) : null,
      leading: IconButton(
        icon: Icon(
          Icons.close, 
          color: isDark ? AppColors.darkAccentBlue : theme.iconTheme.color,
          size: 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Edit Profile',
        style: TextStyle(
          color: isDark ? AppColors.darkAccentBlue : theme.textTheme.headlineSmall?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileImageSection(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      child: Column(
        children: [
          Container(
            width: ResponsiveHelper.getIconSize(context, mobile: 100, tablet: 120, desktop: 140),
            height: ResponsiveHelper.getIconSize(context, mobile: 100, tablet: 120, desktop: 140),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
                    : [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 60, desktop: 70)),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppColors.darkGradientStart : AppColors.primary).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: ResponsiveHelper.getIconSize(context, mobile: 50, tablet: 60, desktop: 70),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
              vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [AppColors.darkCardBackground, AppColors.darkElevatedSurface]
                    : [AppColors.gray50, AppColors.gray100],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  size: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
                Text(
                  'Change Photo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: TextFormField(
        controller: _nameController,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Full Name',
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Name is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Email Address',
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneField(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Phone number is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubjectField(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: DropdownButtonFormField<String>(
        value: _selectedSubject,
        decoration: InputDecoration(
          labelText: 'Subject',
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
          ),
        ),
        dropdownColor: isDark ? AppColors.darkCardBackground : AppColors.gray50,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
          size: 28,
        ),
        items: _availableSubjects.map((String subject) {
          return DropdownMenuItem<String>(
            value: subject,
            child: Text(
              subject,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSubject = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a subject';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBioField(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28)),
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      child: TextFormField(
        controller: _bioController,
        maxLines: 4,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'Bio',
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.transparent : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue.withOpacity(0.3) : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              width: 2.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 20, tablet: 24, desktop: 28),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 22, desktop: 26),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Bio is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: ResponsiveLayout(
        mobile: Column(
          children: [
            _buildSaveButton(isDark),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),
            _buildCancelButton(isDark),
          ],
        ),
        tablet: Row(
          children: [
            Expanded(child: _buildCancelButton(isDark)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildSaveButton(isDark)),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildCancelButton(isDark)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildSaveButton(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return Container(
      height: ResponsiveHelper.getButtonHeight(context) + 8,
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkGradientStart,
            AppColors.darkGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ) : null,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.transparent : AppColors.primary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                height: ResponsiveHelper.getIconSize(context, mobile: 24, tablet: 28, desktop: 32),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppColors.darkAccentBlue : AppColors.primary,
                  ),
                ),
              )
            : Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  color: isDark ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton(bool isDark) {
    return Container(
      height: ResponsiveHelper.getButtonHeight(context) + 8,
      decoration: isDark ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCardBackground,
            AppColors.darkElevatedSurface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.darkAccentBlue.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGradientStart.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ) : null,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _onCancel,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? Colors.transparent : null,
          side: BorderSide(
            color: isDark ? Colors.transparent : AppColors.primary,
            width: isDark ? 0 : 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context, mobile: 28, tablet: 32, desktop: 36),
            vertical: ResponsiveHelper.getSpacing(context, mobile: 18, tablet: 20, desktop: 22),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: isDark ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement save profile logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      _showSnackBar('Profile updated successfully!');
      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error updating profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context),
          ),
        ),
      ),
    );
  }
} 
import 'package:core/theme/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_view_bloc.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_view_event.dart' as view_events;
import 'dart:io';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../blocs/profile_edit_bloc.dart';
import '../../blocs/profile_edit_event.dart';
import '../../blocs/profile_edit_state.dart';
import '../../../domain/entities/profile.dart';
import '../widgets/edit_profile_app_bar.dart';
import '../widgets/edit_profile_form.dart';

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
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Profile? _currentProfile;

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

    // Load profile data from server
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileEditBloc>().add(LoadProfile());
    });
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
      backgroundColor: isDark ? const Color(0xFF181C2A) : theme.scaffoldBackgroundColor,
      appBar: EditProfileAppBar(theme: theme, isDark: isDark),
      body: BlocListener<ProfileEditBloc, ProfileEditState>(
        listener: (context, state) {
          if (state is ProfileEditLoaded) {
            // Populate form fields with loaded profile data
            _populateFormWithProfile(state.profile);
            setState(() {
              _isLoading = false;
            });
          } else if (state is ProfileEditSuccess) {
            _showSnackBar('تم تحديث الملف الشخصي بنجاح');
            context.read<ProfileViewBloc>().add(view_events.UpdateProfileData(state.updatedProfile));
            Navigator.of(context).pop();
          } else if (state is ProfileEditError) {
            _showSnackBar('خطأ: ${state.message}');
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
          builder: (context, state) {
            // Update loading state based on bloc state
            if (state is ProfileEditLoading) {
              _isLoading = true;
            } else if (state is ProfileEditSuccess || state is ProfileEditError) {
              _isLoading = false;
            }
            
            if (state is ProfileEditLoading) {
              return _buildLoadingState();
            } else if (state is ProfileEditError) {
              return _buildErrorState(state.message);
            }
            
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: EditProfileForm(
                  formKey: _formKey,
                  isDark: isDark,
                  selectedImage: _selectedImage,
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  bioController: _bioController,
                  isLoading: _isLoading,
                  onImageTap: _showImagePickerDialog,
                  onSave: _onSave,
                  onCancel: _onCancel,
                ),
              ),
            );
          },
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
      // Create Profile entity from form data
      final profile = Profile(
        id: _currentProfile?.id ?? '1', // Use current profile ID or fallback
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        avatarUrl: _currentProfile?.avatarUrl ?? '', // Preserve current avatar
        contactInfo: ContactInfo(
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
        socialMedia: _currentProfile?.socialMedia ?? [], // Preserve current social media
        professionalInfo: _currentProfile?.professionalInfo ?? ProfessionalInfo(
          subjectsTaught: _currentProfile?.professionalInfo.subjectsTaught ?? [],
          gradeLevels: _currentProfile?.professionalInfo.gradeLevels ?? [],
          department: _currentProfile?.professionalInfo.department ?? '',
          qualifications: _currentProfile?.professionalInfo.department ?? '',
          certifications: _currentProfile?.professionalInfo.certifications ?? '',
        ),
      );

      // Send to Bloc with optional image file
      context.read<ProfileEditBloc>().add(SaveProfile(profile, imageFile: _selectedImage));
    } catch (e) {
      _showSnackBar('Error preparing profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  void _populateFormWithProfile(Profile profile) {
    _currentProfile = profile;
    _nameController.text = profile.name;
    _emailController.text = profile.contactInfo.email;
    _phoneController.text = profile.contactInfo.phone;
    _bioController.text = profile.bio;
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الملف الشخصي...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text('حدث خطأ أثناء تحميل الملف الشخصي'),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileEditBloc>().add(LoadProfile());
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
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
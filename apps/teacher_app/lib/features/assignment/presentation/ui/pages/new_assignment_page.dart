import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/section_title.dart';
import '../widgets/action_tile.dart';
import 'package:core/theme/constants/app_colors.dart';

class NewAssignmentPage extends StatefulWidget {
  const NewAssignmentPage({super.key});

  @override
  State<NewAssignmentPage> createState() => _NewAssignmentPageState();
}

class _NewAssignmentPageState extends State<NewAssignmentPage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  // Form data
  String? _selectedClass;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  // Available classes
  final List<String> _availableClasses = [
    'Choose Target',
    'Class A',
    'Class B',
    'Class C',
    'Class D',
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
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
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
                    _buildTitleField(isDark),
                    _buildDescriptionField(isDark),
                    _buildAttachmentsSection(isDark),
                    _buildDueDateSection(isDark),
                    _buildTargetClassSection(isDark),
                    _buildMaxGradeSection(isDark),
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
      backgroundColor: isDark 
          ? AppColors.darkGradientStart
          : theme.appBarTheme.backgroundColor,
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
      title: ResponsiveText(
        'New Assignment',
        mobileSize: 18,
        tabletSize: 20,
        desktopSize: 22,
        style: TextStyle(
          color: isDark ? AppColors.darkAccentBlue : theme.textTheme.headlineSmall?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTitleField(bool isDark) {
    return CustomTextFormField(
      label: 'Title',
      placeholder: 'Assignment Title',
      controller: _titleController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Title is required';
        }
        if (value.trim().length < 3) {
          return 'Title must be at least 3 characters';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(bool isDark) {
    return CustomTextFormField(
      label: 'Description',
      placeholder: 'Assignment Description',
      controller: _descriptionController,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Description is required';
        }
        if (value.trim().length < 10) {
          return 'Description must be at least 10 characters';
        }
        return null;
      },
    );
  }

  Widget _buildAttachmentsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Attachments', icon: Icons.attach_file, iconColor: isDark ? AppColors.info : AppColors.info),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: isDark ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCardBackground,
                AppColors.darkElevatedSurface,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGradientStart.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ) : null,
          child: Column(
            children: [
              ActionTile(
                icon: Icons.cloud_download,
                text: 'Add from Drive',
                onTap: _onAddFromDrive,
                iconColor: isDark ? AppColors.info : AppColors.info,
              ),
              ActionTile(
                icon: Icons.upload_file,
                text: 'Upload File',
                onTap: _onUploadFile,
                iconColor: isDark ? AppColors.success : AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Due Date & Time', icon: Icons.schedule, iconColor: isDark ? AppColors.warning : AppColors.warning),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: isDark ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCardBackground,
                AppColors.darkElevatedSurface,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGradientStart.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ) : null,
          child: ActionTile(
            icon: Icons.event_available,
            text: _getDueDateText(),
            onTap: _onSelectDateAndTime,
            iconColor: isDark ? AppColors.warning : AppColors.warning,
          ),
        ),
      ],
    );
  }

    Widget _buildTargetClassSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Target Classes/Students', icon: Icons.groups, iconColor: isDark ? AppColors.secondary : AppColors.secondary),
        Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
          ),
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
                color: AppColors.darkGradientStart.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ) : null,
          child: DropdownButtonFormField<String>(
            value: _selectedClass,
            decoration: InputDecoration(
              labelText: 'Select Classes/Students',
              filled: true,
              fillColor: isDark ? Colors.transparent : Colors.grey[50],
              labelStyle: TextStyle(
                color: isDark ? AppColors.darkAccentBlue : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
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
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? AppColors.darkAccentBlue : AppColors.primary,
              size: 28,
            ),
            items: _availableClasses.map((String classItem) {
              return DropdownMenuItem<String>(
                value: classItem == 'Choose Target' ? null : classItem,
                                  child: Text(
                    classItem,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedClass = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a target class';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaxGradeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Maximum Grade', icon: Icons.star, iconColor: isDark ? AppColors.accent : AppColors.accent),
        CustomTextFormField(
          label: 'Points',
          placeholder: 'e.g., 100',
          controller: _pointsController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Points are required';
            }
            final points = int.tryParse(value);
            if (points == null || points <= 0) {
              return 'Points must be a positive number';
            }
            if (points > 1000) {
              return 'Points cannot exceed 1000';
            }
            return null;
          },
        ),
      ],
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
            _buildSaveAsDraftButton(isDark),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),
            _buildPublishButton(isDark),
          ],
        ),
        tablet: Row(
          children: [
            Expanded(child: _buildSaveAsDraftButton(isDark)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildPublishButton(isDark)),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildSaveAsDraftButton(isDark)),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildPublishButton(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveAsDraftButton(bool isDark) {
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
        onPressed: _isLoading ? null : _onSaveAsDraft,
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
                'Save as Draft',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  color: isDark ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildPublishButton(bool isDark) {
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
        onPressed: _isLoading ? null : _onPublish,
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
                'Publish',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
                  color: isDark ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  // Helper methods
  String _getDueDateText() {
    if (_selectedDate == null) {
      return 'Select Date & Time';
    }
    final dateStr = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
    if (_selectedTime != null) {
      return '$dateStr at ${_selectedTime!.format(context)}';
    }
    return dateStr;
  }



  // Event handlers
  void _onAddFromDrive() {
    // TODO: Implement Google Drive integration
    _showSnackBar('Google Drive integration coming soon!');
  }

  void _onUploadFile() {
    // TODO: Implement file upload
    _showSnackBar('File upload feature coming soon!');
  }

  Future<void> _onSelectDateAndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );

      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = pickedTime;
      });

             // Update due date
    }
  }

  Future<void> _onSaveAsDraft() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement save as draft logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      _showSnackBar('Assignment saved as draft successfully!');
      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error saving draft: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onPublish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement publish logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      _showSnackBar('Assignment published successfully!');
      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error publishing assignment: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).primaryColor,
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
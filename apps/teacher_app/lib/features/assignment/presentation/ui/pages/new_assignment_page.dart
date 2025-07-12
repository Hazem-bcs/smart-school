import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/responsive_helper.dart';
import '../../../../../core/responsive_widgets.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/section_title.dart';
import '../widgets/action_tile.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContent(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                  vertical: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16),
                ),
                children: [
                  _buildTitleField(),
                  _buildDescriptionField(),
                  _buildAttachmentsSection(),
                  _buildDueDateSection(),
                  _buildTargetClassSection(),
                  _buildMaxGradeSection(),
                  _buildActionButtons(),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFF0E141B)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: ResponsiveText(
        'New Assignment',
        mobileSize: 18,
        tabletSize: 20,
        desktopSize: 22,
        style: const TextStyle(
          color: Color(0xFF0E141B),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTitleField() {
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

  Widget _buildDescriptionField() {
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

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Attachments', icon: Icons.attach_file),
        ActionTile(
          icon: Icons.cloud,
          text: 'Add from Drive',
          onTap: _onAddFromDrive,
          iconColor: Colors.blue,
        ),
        ActionTile(
          icon: Icons.attach_file,
          text: 'Upload File',
          onTap: _onUploadFile,
          iconColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Due Date & Time', icon: Icons.calendar_today),
        ActionTile(
          icon: Icons.calendar_today,
          text: _getDueDateText(),
          onTap: _onSelectDateAndTime,
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildTargetClassSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Target Classes/Students', icon: Icons.people),
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedClass,
            decoration: InputDecoration(
              labelText: 'Select Classes/Students',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
                vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
              ),
            ),
            items: _availableClasses.map((String classItem) {
              return DropdownMenuItem<String>(
                value: classItem == 'Choose Target' ? null : classItem,
                child: Text(classItem),
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

  Widget _buildMaxGradeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Maximum Grade', icon: Icons.grade),
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

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: ResponsiveLayout(
        mobile: Column(
          children: [
            _buildSaveAsDraftButton(),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),
            _buildPublishButton(),
          ],
        ),
        tablet: Row(
          children: [
            Expanded(child: _buildSaveAsDraftButton()),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildPublishButton()),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _buildSaveAsDraftButton()),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(child: _buildPublishButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveAsDraftButton() {
    return SizedBox(
      height: ResponsiveHelper.getButtonHeight(context),
      child: OutlinedButton(
        onPressed: _isLoading ? null : _onSaveAsDraft,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                height: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              )
            : ResponsiveText(
                'Save as Draft',
                mobileSize: 14,
                tabletSize: 16,
                desktopSize: 18,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onPublish,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4296EA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                height: ResponsiveHelper.getIconSize(context, mobile: 20, tablet: 24, desktop: 28),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : ResponsiveText(
                'Publish',
                mobileSize: 14,
                tabletSize: 16,
                desktopSize: 18,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
import 'package:flutter/material.dart';
import 'package:teacher_app/features/new_assignment/presentation/blocs/new_assignment_event.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../../../core/responsive/responsive_widgets.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../widgets/new_assignment_title_field.dart';
import '../widgets/new_assignment_description_field.dart';
import '../widgets/new_assignment_class_dropdown.dart';
import '../widgets/new_assignment_points_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/new_assignment_bloc.dart';
import '../../blocs/new_assignment_state.dart';
import '../widgets/new_assignment_app_bar.dart';
import '../widgets/new_assignment_attachments_section.dart';
import '../widgets/new_assignment_due_date_section.dart';
import '../widgets/new_assignment_action_buttons.dart';
import 'package:teacher_app/features/new_assignment/domain/entities/new_assignment_entity.dart';


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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedClass = 'Choose Target';
  List<String> availableClasses = ['Choose Target'];

  @override
  void initState() {
    super.initState();
    context.read<NewAssignmentBloc>().add(GetClassesEvent());
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

    String? validateTitle(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Title is required';
      }
      if (value.trim().length < 3) {
        return 'Title must be at least 3 characters';
      }
      return null;
    }

    String? validateDescription(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Description is required';
      }
      if (value.trim().length < 10) {
        return 'Description must be at least 10 characters';
      }
      return null;
    }

    String? validatePoints(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Points are required';
      }
      final points = int.tryParse(value);
      if (points == null || points <= 0) {
        return 'Points must be a positive number';
      }
      if (points > 100 || points < 0) {
        return 'Points cannot exceed 100';
      }
      return null;
    }

    String? validateClass(String? value) {
      if (value == null || value.isEmpty || value == 'Choose Target') {
        return 'Please select a target class';
      }
      return null;
    }

    return BlocListener<NewAssignmentBloc, NewAssignmentState>(
      listener: (context, state) {
        if (state is NewAssignmentSent) {
          _showSnackBar('Assignment published successfully!');
          Navigator.of(context).pop();
        } else if (state is NewAssignmentFailure) {
          _showSnackBar('Error:  ${state.message}');
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : theme.scaffoldBackgroundColor,
        appBar: NewAssignmentAppBar(
          theme: theme,
          isDark: isDark,
          onClose: () => Navigator.of(context).pop(),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: isDark
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.darkBackground,
                          AppColors.darkBackground.withOpacity(0.95),
                        ],
                      ),
                    )
                  : null,
              child: ResponsiveContent(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                      vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
                    ),
                    children: [
                       NewAssignmentDueDateSection(
                        isDark: isDark,
                        dueDateText: _getDueDateText(),
                        onSelectDateAndTime: _onSelectDateAndTime,
                      ),
                      
                      NewAssignmentTitleField(
                        controller: _titleController,
                        isDark: isDark,
                        validator: validateTitle,
                      ),
                      NewAssignmentDescriptionField(
                        controller: _descriptionController,
                        isDark: isDark,
                        validator: validateDescription,
                      ),
                      
                      NewAssignmentAttachmentsSection(
                        isDark: isDark,
                        onAddFromDrive: _onAddFromDrive,
                        onUploadFile: _onUploadFile,
                      ),
                      NewAssignmentPointsField(
                        controller: _pointsController,
                        isDark: isDark,
                        validator: validatePoints,
                      ),
                     
                      
                      
                      BlocBuilder<NewAssignmentBloc, NewAssignmentState>(
                        builder: (context, state) {
                          print('here');
                          if(state is NewAssignmentClassesLoaded) {
                            availableClasses =  ['Choose Target' , ...state.classes];
                            }
                          return NewAssignmentClassDropdown(
                            selectedClass: _selectedClass,
                            availableClasses: availableClasses,
                            onChanged: (val) => setState(() =>  _selectedClass = val),
                            isDark: isDark,
                            validator: validateClass,
                          );
                        },
                      ),
                      BlocBuilder<NewAssignmentBloc, NewAssignmentState>(
                        builder: (context, state) {
                          final isLoading = state is NewAssignmentLoading;
                          return NewAssignmentActionButtons(
                            isDark: isDark,
                            isLoading: isLoading,
                            onSaveAsDraft: _onSaveAsDraft,
                            onPublish: _onPublish,
                          );
                        },
                      ),
                      SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 80, tablet: 100, desktop: 120)),
                    ],
                  ),
                ),
              ),
            ),
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
    _showSnackBar('Google Drive integration coming soon!');
  }

  void _onUploadFile() {
    _showSnackBar('File upload feature coming soon!');
  }

  Future<void> _onSelectDateAndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
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
    // TODO: Implement save as draft logic
    _showSnackBar('Save as draft feature coming soon!');
  }

  Future<void> _onPublish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Create assignment entity

    final assignment = NewAssignmentEntity(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      classId: _selectedClass!,
      dueDate: _selectedDate!,
      points: int.parse(_pointsController.text.trim()),
    );
    // Send event to Bloc
    context.read<NewAssignmentBloc>().add(OnPublish(assignment));
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
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
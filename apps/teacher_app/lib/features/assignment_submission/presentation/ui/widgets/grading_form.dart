import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/index.dart';
import 'package:teacher_app/features/assignment_submission/domain/entities/student_submission.dart';
import '../../blocs/submission_bloc.dart';
import '../../blocs/submission_state.dart';
import '../../blocs/submission_event.dart';

class GradingForm extends StatefulWidget {
  const GradingForm({super.key});

  @override
  State<GradingForm> createState() => _GradingFormState();
}

class _GradingFormState extends State<GradingForm> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();
  final _commentsController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _gradeController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionBloc, SubmissionState>(
      builder: (context, state) {
        if (state is SubmissionDataLoaded) {
          final student = state.students[state.currentStudentIndex];
          // إذا تغير الطالب الحالي، أفرغ الحقول
          if (_gradeController.text.isNotEmpty && _gradeController.text != (student.grade ?? '')) {
            _gradeController.text = student.grade?.toString() ?? '';
          }
          if (_commentsController.text.isNotEmpty && _commentsController.text != (student.feedback ?? '')) {
            _commentsController.text = student.feedback ?? '';
          }
          return _buildGradingForm(context, student);
        } else if (state is GradeSubmissionError) {
          // في حالة خطأ التصحيح، نعرض النموذج مع القيم السابقة
          final student = state.students[state.currentStudentIndex];
          // إعادة تعبئة الحقول بالقيم السابقة
          _gradeController.text = state.grade;
          _commentsController.text = state.feedback;
          return _buildGradingForm(context, student, isErrorState: true);
        }
        return _buildLoadingForm(context);
      },
    );
  }

  Widget _buildGradingForm(BuildContext context, StudentSubmission student, {bool isErrorState = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Initialize controllers with current values if editing
    if (_isEditing && student.isGraded && !isErrorState) {
      if (_gradeController.text.isEmpty) {
        _gradeController.text = student.grade?.toString() ?? '';
      }
      if (_commentsController.text.isEmpty) {
        _commentsController.text = student.feedback ?? '';
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? AppColors.darkAccentBlue.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: isErrorState ? Border.all(
          color: isDark ? AppColors.darkDestructive : AppColors.error,
          width: 2,
        ) : null,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with current grade display
            Row(
              children: [
                Expanded(
                  child: Text(
                    'تصحيح الواجب',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
                if (student.isGraded && !_isEditing && !isErrorState)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSuccess : AppColors.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'الدرجة: ${student.grade}/100',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            
            if (isErrorState) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDestructive.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? AppColors.darkDestructive : AppColors.error,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: isDark ? AppColors.darkDestructive : AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'فشل في حفظ التصحيح. حاول مجددًا.',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkDestructive : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            if (student.isGraded && !_isEditing && !isErrorState) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkElevatedSurface : AppColors.gray50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : AppColors.gray300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الدرجة الحالية: ${student.grade}/100',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    if (student.feedback?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text(
                        'التعليق: ${student.feedback}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('تعديل الدرجة'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                    ),
                    foregroundColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 20),
              
              // Grade Field
              TextFormField(
                controller: _gradeController,
                enabled: !student.isGraded || _isEditing || isErrorState,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الدرجة (0-100)',
                  hintText: 'أدخل الدرجة...',
                  prefixIcon: Icon(
                    Icons.grade,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray500,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkElevatedSurface : AppColors.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkDivider : AppColors.gray300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkDivider : AppColors.gray300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  ),
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الدرجة';
                  }
                  final grade = double.tryParse(value);
                  if (grade == null || grade < 0 || grade > 100) {
                    return 'يجب أن تكون الدرجة بين 0 و 100';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Comments Field
              TextFormField(
                controller: _commentsController,
                maxLines: 4,
                enabled: !student.isGraded || _isEditing || isErrorState,
                decoration: InputDecoration(
                  labelText: 'تعليقات',
                  hintText: 'أضف ملاحظات أو تعليق...',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: isDark ? AppColors.darkElevatedSurface : AppColors.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkDivider : AppColors.gray300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkDivider : AppColors.gray300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
                  ),
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.gray400,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  if (_isEditing || isErrorState) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _gradeController.clear();
                            _commentsController.clear();
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('إلغاء'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: isDark ? AppColors.darkDestructive : AppColors.error,
                          ),
                          foregroundColor: isDark ? AppColors.darkDestructive : AppColors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _gradeController.clear();
                          _commentsController.clear();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('مسح'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: isDark ? AppColors.darkAccentBlue : AppColors.info,
                          ),
                          foregroundColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SubmissionBloc>().add(SubmitGrade(
                            submissionId: student.id,
                            grade: _gradeController.text,
                            feedback: _commentsController.text,
                          ));
                          // Reset editing state after submission
                          if (_isEditing) {
                            setState(() {
                              _isEditing = false;
                            });
                          }
                        }
                      },
                      icon: Icon(_isEditing ? Icons.update : Icons.check),
                      label: Text(_isEditing ? 'تحديث الدرجة' : 'حفظ الدرجة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkAccentBlue : AppColors.info,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: isDark ? 4 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingForm(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? AppColors.darkAccentBlue.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 100,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSecondaryText : AppColors.gray300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
} 
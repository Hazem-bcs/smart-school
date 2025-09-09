
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/theme/index.dart';
import 'package:core/widgets/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:core/network/dio_client.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../data/data_sources/assignment_remote_data_source.dart';
import '../../data/repositories_impl/assignment_repository_impl.dart';
import '../../domain/usecases/submit_assignment_usecase.dart';

class AssignmentDetailsPage extends StatefulWidget {
  final AssignmentEntity assignment;

  const AssignmentDetailsPage({super.key, required this.assignment});

  @override
  State<AssignmentDetailsPage> createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage>
    with TickerProviderStateMixin {
  final TextEditingController _submissionTextController = TextEditingController();
  File? _selectedImage;

  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _submissionTextController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitAssignment() async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final dioClient = GetIt.I.isRegistered<DioClient>() ? GetIt.I<DioClient>() : null;
      final dataSource = AssignmentRemoteDataSourceImpl(dioClient: dioClient);
      final repo = AssignmentRepositoryImpl(dataSource);
      final useCase = SubmitAssignmentUseCase(repo);

      final result = await useCase(
        assignmentId: widget.assignment.assignmentId,
        studentId: '123',
        answerText: _submissionTextController.text.trim(),
        imagePath: _selectedImage?.path,
      );

      result.fold(
        (failure) {
          scaffold.showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (_) {
          scaffold.showSnackBar(
            const SnackBar(content: Text('تم إرسال المهمة بنجاح')),
          );
          Navigator.pop(context, true);
        },
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text('حدث خطأ غير متوقع: $e')),
      );
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AssignmentDetailsAppBar(
        points: widget.assignment.points,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssignmentHeaderSection(
                  assignment: widget.assignment,
                  getStatusText: _getStatusText,
                  getStatusColor: _getStatusColor,
                  getStatusIcon: _getStatusIcon,
                ),
                const SizedBox(height: 24),
                AssignmentDescriptionSection(
                  description: widget.assignment.description,
                ),
                const SizedBox(height: 24),
                AssignmentInfoSection(
                  assignment: widget.assignment,
                  formatDate: _formatDate,
                ),
                const SizedBox(height: 24),
                if (widget.assignment.teacherImageAttachment != null)
                  AssignmentTeacherImageSection(
                    imageUrl: widget.assignment.teacherImageAttachment!,
                  ),
                const SizedBox(height: 24),
                AssignmentSubmissionSection(
                  assignment: widget.assignment,
                  submissionTextController: _submissionTextController,
                  selectedImage: _selectedImage,
                  onPickImage: _pickImageFromGallery,
                  onSubmit: _submitAssignment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for status and date formatting

  String _getStatusText() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return 'مُقيّم';
    } else if (widget.assignment.submissionStatus == SubmissionStatus.submitted) {
      return 'تم التسليم';
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return 'متأخر';
    } else {
      return 'لم يتم التسليم بعد';
    }
  }

  Color _getStatusColor() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return Colors.green;
    } else if (widget.assignment.submissionStatus == SubmissionStatus.submitted) {
      return AppColors.primary;
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return Icons.check_circle;
    } else if (widget.assignment.submissionStatus == SubmissionStatus.submitted) {
      return Icons.upload_file;
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return Icons.warning;
    } else {
      return Icons.assignment;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'منذ ${difference.abs()} يوم';
    } else if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference < 7) {
      return 'خلال $difference أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// ------------------- Widgets -------------------

class AssignmentDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int points;
  final VoidCallback onBack;

  const AssignmentDetailsAppBar({
    Key? key,
    required this.points,
    required this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBarWidget(
      title: 'تفاصيل المهمة',
      leadingIcon: Icons.arrow_back,
      onLeadingPressed: onBack,
      automaticallyImplyLeading: false,
      actions: [
        AppBarActions.counter(
          text: '$points نقطة',
          isDark: isDark,
        ),
      ],
    );
  }
}

class AssignmentHeaderSection extends StatelessWidget {
  final AssignmentEntity assignment;
  final String Function() getStatusText;
  final Color Function() getStatusColor;
  final IconData Function() getStatusIcon;

  const AssignmentHeaderSection({
    Key? key,
    required this.assignment,
    required this.getStatusText,
    required this.getStatusColor,
    required this.getStatusIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7B61FF).withOpacity(0.1),
            const Color(0xFF7B61FF).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF7B61FF).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B61FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  assignment.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: getStatusColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  getStatusIcon(),
                  color: getStatusColor(),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  getStatusText(),
                  style: TextStyle(
                    color: getStatusColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssignmentDescriptionSection extends StatelessWidget {
  final String description;

  const AssignmentDescriptionSection({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: const Color(0xFF7B61FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'وصف المهمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class AssignmentInfoSection extends StatelessWidget {
  final AssignmentEntity assignment;
  final String Function(DateTime) formatDate;

  const AssignmentInfoSection({
    Key? key,
    required this.assignment,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFF7B61FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'معلومات المهمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AssignmentInfoRow(
            label: 'تاريخ التسليم:',
            value: formatDate(assignment.dueDate),
            icon: Icons.calendar_today,
            isOverdue: DateTime.now().isAfter(assignment.dueDate),
          ),
          const SizedBox(height: 12),
          AssignmentInfoRow(
            label: 'النقاط:',
            value: '${assignment.points} نقطة',
            icon: Icons.scoreboard,
          ),
          const SizedBox(height: 12),
          AssignmentInfoRow(
            label: 'تاريخ الإنشاء:',
            value: formatDate(assignment.createdAt),
            icon: Icons.create,
          ),
        ],
      ),
    );
  }
}

class AssignmentInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isOverdue;

  const AssignmentInfoRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.isOverdue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isOverdue
                ? Colors.red.withOpacity(0.1)
                : const Color(0xFF7B61FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isOverdue ? Colors.red : const Color(0xFF7B61FF),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isOverdue
                      ? Colors.red
                      : theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AssignmentTeacherImageSection extends StatelessWidget {
  final String imageUrl;

  const AssignmentTeacherImageSection({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isNetwork = imageUrl.startsWith('http');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.image,
                color: const Color(0xFF7B61FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'المرفقات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isNetwork
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: SmartSchoolLoading(
                              type: LoadingType.pulse,
                              size: 40,
                              showMessage: false,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 48),
                                SizedBox(height: 8),
                                Text('فشل في تحميل الصورة'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 48),
                                SizedBox(height: 8),
                                Text('الصورة غير متوفرة في الأصول'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssignmentSubmissionSection extends StatelessWidget {
  final AssignmentEntity assignment;
  final TextEditingController submissionTextController;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;

  const AssignmentSubmissionSection({
    super.key,
    required this.assignment,
    required this.submissionTextController,
    required this.selectedImage,
    required this.onPickImage,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {

    if (assignment.submissionStatus == SubmissionStatus.graded) {
      return AssignmentGradedView(
        grade: assignment.grade,
        points: assignment.points,
        teacherNote: assignment.teacherNote,
      );
    } else if (assignment.submissionStatus == SubmissionStatus.submitted) {
      return const AssignmentSubmittedView();
    } else {
      return AssignmentSubmissionView(
        submissionTextController: submissionTextController,
        selectedImage: selectedImage,
        onPickImage: onPickImage,
        onSubmit: onSubmit,
      );
    }
  }
}

class AssignmentGradedView extends StatelessWidget {
  final int? grade;
  final int points;
  final String? teacherNote;

  const AssignmentGradedView({
    Key? key,
    required this.grade,
    required this.points,
    this.teacherNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'تم التقييم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'الدرجة: ${grade ?? '-'} / $points',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          if (teacherNote != null && teacherNote!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'ملاحظات المعلم:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                teacherNote!,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AssignmentSubmittedView extends StatelessWidget {
  const AssignmentSubmittedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'تم تسليم المهمة!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'مهمتك في انتظار التقييم من المعلم',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AssignmentSubmissionView extends StatelessWidget {
  final TextEditingController submissionTextController;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;

  const AssignmentSubmissionView({
    Key? key,
    required this.submissionTextController,
    required this.selectedImage,
    required this.onPickImage,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upload_file,
                color: const Color(0xFF7B61FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'تسليم المهمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'إجابتك:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: submissionTextController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'اكتب إجابتك هنا...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF7B61FF), width: 2),
              ),
              filled: true,
              fillColor: theme.cardColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPickImage,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('إضافة صورة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              foregroundColor: const Color(0xFF7B61FF),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (selectedImage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تم اختيار الصورة: ${selectedImage!.path.split('/').last}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B61FF),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'تسليم المهمة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

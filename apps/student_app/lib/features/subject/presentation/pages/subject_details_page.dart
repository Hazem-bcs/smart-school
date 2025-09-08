import 'package:core/domain/entities/subject_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import 'package:core/widgets/unified_loading_indicator.dart';
import '../blocs/subject/subject_bloc.dart';

class SubjectDetailsPage extends StatefulWidget {
  final int subjectId;

  const SubjectDetailsPage({Key? key, required this.subjectId})
      : super(key: key);

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  @override
  void initState() {
    debugPrint('SubjectDetailsPage:initState -> dispatch GetSubjectDetailsEvent id=${widget.subjectId}');
    context.read<SubjectBloc>().add(
      GetSubjectDetailsEvent(id: widget.subjectId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (context, state) {
        if (state is SubjectLoading || state is SubjectInitial) {
          return const Scaffold(
            body: Center(child: SmartSchoolLoading(message: 'جاري تحميل تفاصيل المادة...')),
          );
        }
        if (state is SubjectFailure) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('تعذر تحميل المادة: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('SubjectDetailsPage:Retry -> dispatch GetSubjectDetailsEvent id=${widget.subjectId}');
                      context.read<SubjectBloc>().add(
                        GetSubjectDetailsEvent(id: widget.subjectId),
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is SubjectLoaded) {
          final SubjectEntity subject = state.subjectEntity;
          final String headerTeacher = subject.teacher ?? 'غير محدد';

          return Scaffold(
            appBar: AppBarWidget(
              title: subject.name,
              actions: [
                AppBarActions.refresh(
                  onPressed: () {
                    context.read<SubjectBloc>().add(
                      GetSubjectDetailsEvent(id: widget.subjectId),
                    );
                  },
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                debugPrint('SubjectDetailsPage:RefreshIndicator -> dispatch GetSubjectDetailsEvent id=${widget.subjectId}');
                context.read<SubjectBloc>().add(
                  GetSubjectDetailsEvent(id: widget.subjectId),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, subject),
                      const SizedBox(height: 25),
                      _buildDetailsCard(
                        context,
                        title: 'المعلم',
                        content: headerTeacher,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 15),
                      _buildDetailsCard(
                        context,
                        title: 'الصف والشعبة',
                        content: '${subject.grade} - ${subject.classroom}',
                        icon: Icons.school,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: Text('Unknown state.'));
      },
    );
  }

  Widget _buildHeader(BuildContext context, SubjectEntity subject) {
    final colors = _gradientFor(subject.name);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _pill(icon: Icons.school, label: subject.grade),
                  _pill(icon: Icons.class_, label: subject.classroom),
                  if ((subject.teacher ?? '').isNotEmpty)
                    _pill(icon: Icons.person, label: subject.teacher!),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(
      BuildContext context, {
        required String title,
        required String content,
        required IconData icon,
      }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF7B61FF), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7B61FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5C5C5C),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _gradientFor(String name) {
    final palettes = <List<Color>>[
      [const Color(0xFF7B61FF), const Color(0xFF5E2EFF)],
      [const Color(0xFF00C6FF), const Color(0xFF0072FF)],
      [const Color(0xFFFF6CAB), const Color(0xFF7366FF)],
      [const Color(0xFFFFA726), const Color(0xFFFF7043)],
      [const Color(0xFF42E695), const Color(0xFF3BB2B8)],
    ];
    final index = name.hashCode.abs() % palettes.length;
    return palettes[index];
  }

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 2),
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
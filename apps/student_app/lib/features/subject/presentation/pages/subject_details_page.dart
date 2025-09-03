import 'package:core/domain/entities/subject_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';
import '../../../../widgets/app_loading_widget.dart';
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
            body: Center(child: AppLoadingWidget()),
          );
        }
        if (state is SubjectFailure) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading subject: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubjectBloc>().add(
                        GetSubjectDetailsEvent(id: widget.subjectId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is SubjectLoaded) {
          final SubjectEntity subject = state.subjectEntity;
          final String teachersText = subject.teachers
              .map((t) => '• $t')
              .join('\n');
          final String notesText = subject.notes
              .map((n) => '• $n')
              .join('\n');

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
                        title: 'المدرسين المتاحين',
                        content: teachersText,
                        icon: Icons.people_alt,
                      ),
                      const SizedBox(height: 15),
                      _buildDetailsCard(
                        context,
                        title: 'ملاحظات',
                        content: notesText,
                        icon: Icons.note,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject.name,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7B61FF),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'هذه المادة تعتبر أساسية لفهم المفاهيم العلمية المتقدمة وتطوير مهارات التفكير النقدي.',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF5C5C5C),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(
      BuildContext context, {
        required String title,
        required String content,
        required IconData icon,
      }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF7B61FF), size: 30),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B61FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 1, color: Colors.black12),
            const SizedBox(height: 15),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5C5C5C),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
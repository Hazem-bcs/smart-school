import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/theme/constants/app_text_style.dart';
import 'package:core/theme/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
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
    return Scaffold(
      body: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          if (state is SubjectLoading || state is SubjectInitial) {
            return const Center(child: AppLoadingWidget());
          }
          if (state is SubjectFailure) {
            return Center(
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
            );
          }
          if (state is SubjectLoaded) {
            final SubjectEntity subject = state.subjectEntity;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  subject.name,
                  style: AppTextStyle.appBarTitle(context),
                ),
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: primaryColor,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'subject-image-${subject.id}',
                      child: Image.network(
                        subject.image,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 250,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.book,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'هذه المادة تعتبر أساسية لفهم المفاهيم العلمية المتقدمة وتطوير مهارات التفكير النقدي.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDetailsCard(
                            context,
                            title: 'المدرسين المتاحين',
                            content: '• أ. أحمد محمود\n• د. سارة فؤاد',
                            icon: Icons.people_alt,
                          ),
                          SizedBox(height: 10,),
                          _buildDetailsCard(
                            context,
                            title: 'ملاحظات',
                            content: ' •  دروس أسبوعياً 5 \n',
                            icon: Icons.note,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Unknown state.'));
        },
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            Text(
              content,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

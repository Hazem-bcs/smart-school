import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:smart_school/features/subject/presentation/pages/subject_details_page.dart';
import '../../../../widgets/app_exports.dart';
import '../blocs/subject/subject_bloc.dart';

final List<SubjectEntity> dummySubjects = [
  SubjectEntity(id: 1, name: 'الرياضيات', image: 'assets/images/img.png'),
  SubjectEntity(
    id: 2,
    name: 'اللغة العربية',
    image: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=Arabic',
  ),
  SubjectEntity(
    id: 3,
    name: 'العلوم',
    image: 'https://via.placeholder.com/150/FF9800/FFFFFF?text=Science',
  ),
  SubjectEntity(
    id: 4,
    name: 'اللغة الإنجليزية',
    image: 'https://via.placeholder.com/150/9C27B0/FFFFFF?text=English',
  ),
  SubjectEntity(
    id: 5,
    name: 'التاريخ',
    image: 'https://via.placeholder.com/150/795548/FFFFFF?text=History',
  ),
];

class SubjectsPage extends StatefulWidget {


  const SubjectsPage({Key? key, }) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late SubjectBloc subjectBloc;

  @override
  void initState() {
    context.read<SubjectBloc>().add(GetSubjectDetailsEvent(id:1));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.subject),
      body: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          if (state is SubjectLoading || state is SubjectInitial) {
            return AppLoadingWidget();
          }
          if (state is SubjectFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      // context.read<SubjectBloc>().add(
                      //   GetSubjectEvent(id: ),
                      // );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: dummySubjects.length,
              itemBuilder: (context, index) {
                final subject = dummySubjects[index];
                return AppSubjectCard(
                  subject: subject,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                            SubjectDetailsPage(subjectId: subject.id),
                      ),
                    );
                  },
                );
              },
            );

        },
      ),
    );
  }
}

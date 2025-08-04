import 'package:smart_school/features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import 'package:smart_school/features/subject/presentation/pages/subject_details_page.dart';
import '../../../../widgets/app_exports.dart';


class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late SubjectListBloc subjectBloc;

  @override
  void initState() {
    context.read<SubjectListBloc>().add(GetSubjectListEvent());
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
      body: BlocBuilder<SubjectListBloc, SubjectListState>(
        builder: (context, state) {
          if (state is SubjectListLoading || state is SubjectListInitial) {
            return AppLoadingWidget();
          }
          if (state is SubjectListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubjectListBloc>().add(
                        GetSubjectListEvent(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is SubjectListLoaded) {
            if (state.subjectEntityList.isEmpty) {
              return const Center(
                child: Text('No subjects found. Pleasee try again later.'),
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
              itemCount: state.subjectEntityList.length,
              itemBuilder: (context, index) {
                final subject = state.subjectEntityList[index];
                return AppSubjectCard(
                  subject: subject,
                  onTap: () {
                    Navigator.of(context).push(
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
          }
          return Text("data");
        },
      ),
    );
  }
}

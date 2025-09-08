import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import 'package:smart_school/routing/navigation_extension.dart';
import '../../../../widgets/app_exports.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:core/widgets/unified_loading_indicator.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late SubjectListBloc subjectBloc;

  @override
  void initState() {
    debugPrint('SubjectsPage:initState -> dispatch GetSubjectListEvent');
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
      appBar: AppBarWidget(
        title: AppStrings.subject,
        actions: [
          AppBarActions.refresh(
            onPressed: () {
              debugPrint('SubjectsPage:AppBar refresh tapped -> dispatch GetSubjectListEvent');
              context.read<SubjectListBloc>().add(GetSubjectListEvent());
            },
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      body: BlocBuilder<SubjectListBloc, SubjectListState>(
        builder: (context, state) {
          if (state is SubjectListLoading || state is SubjectListInitial) {
            return CommonLoadingStates.dataLoading();
          }
          if (state is SubjectListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حدث خطأ: ${state.message}'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SubjectListBloc>().add(
                        GetSubjectListEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          if (state is SubjectListLoaded) {
            if (state.subjectEntityList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لا توجد مواد حالياً، حاول لاحقاً.'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<SubjectListBloc>().add(
                          GetSubjectListEvent(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('تحديث'),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                debugPrint('SubjectsPage:RefreshIndicator -> dispatch GetSubjectListEvent');
                context.read<SubjectListBloc>().add(GetSubjectListEvent());
              },
              child: GridView.builder(
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
                      debugPrint('SubjectsPage:Tap subject id=${subject.id}, name=${subject.name}');
                      context.goToSubjectDetails(subject.id);
                    },
                  );
                },
              ),
            );
          }
          return Text("data");
        },
      ),
    );
  }
}
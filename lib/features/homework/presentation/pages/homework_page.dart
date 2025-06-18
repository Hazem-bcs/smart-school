import 'package:smart_school/widgets/app_exports.dart';

import '../../domain/entites/homework_entity.dart';
import '../blocs/homework_bloc.dart';
class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {

  @override
  void initState() {
    context.read<HomeworkBloc>().add(GetHomeworksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.homeWork),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state is HomeworkLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeworkLoaded) {
            return _buildHomeworkList(state.homeworkList);
          } else if (state is HomeworkFailure) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildHomeworkList(List<HomeworkEntity> homeworks) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: homeworks.length,
      itemBuilder: (context, index) {
        return HomeworkCard(homework: homeworks[index]);
      },
    );
  }
}
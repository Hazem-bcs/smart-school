import 'package:smart_school/widgets/app_exports.dart';


class HomeworksPage extends StatefulWidget {
  const HomeworksPage({super.key});

  @override
  State<HomeworksPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBarWidget(title: 'homeWork',),
      body: ListView(
        children: [
          SizedBox(height: 100, width: 500),
          HomeworkCard(
            homework: HomeworkModel(
              id: '1',
              title: 'الدرس العاشر',
              subject: "رياضيات",
              assignedDate: DateTime(2025, 6, 16),
              dueDate: DateTime(2025, 6, 19),
              status: HomeworkStatus.completed,
            ),
          ),
        ],
      ),
    );
  }
}

// main.dart or a new file e.g., 'homework_card.dart'

// Make sure you have the Homework model from the previous step

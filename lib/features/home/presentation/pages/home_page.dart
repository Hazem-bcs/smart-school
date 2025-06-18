import 'package:smart_school/widgets/app_exports.dart';

import '../../../../widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/addPost');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: AppDrawerWidget(),
      appBar: AppBarWidget(title: AppStrings.smartSchool),
      body: Column(
        children: [
          PostWidget(),
        ],
      ),
    );
  }
}

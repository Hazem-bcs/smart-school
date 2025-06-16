import 'package:smart_school/widgets/app_exports.dart';

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
      appBar: AppBar(
        title: Text(AppStrings.smartSchool,style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),

      body: Column(
        children: [
          // AppBarImageWidget(isImage: false,height: 80,title: AppStrings.smartSchool,),
          PostWidget(),
        ],
      ),
    );
  }
}

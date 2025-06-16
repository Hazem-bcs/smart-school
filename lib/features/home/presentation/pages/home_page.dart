import 'package:flutter/material.dart';
import 'package:smart_school/features/post/presentation/widgets/post_widget.dart';
import 'package:smart_school/theme/constants/colors.dart';

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
      drawer: Drawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Smart School",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: PostWidget(),
    );
  }
}

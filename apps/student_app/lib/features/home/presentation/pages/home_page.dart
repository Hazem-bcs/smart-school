import 'package:core/theme/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_school/features/post/presentation/widgets/post_widget.dart';

import '../../../schedule/presentation/pages/schedule_page.dart';
import '../widgets/app_drawer.dart';

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
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => ScheduleScreen()),
          // );
        },

        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: AppDrawerWidget(),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/tutorChatView');
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 20.0),
              child: SvgPicture.asset('assets/svg/chat.svg'),
            ),
          ),
        ],
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

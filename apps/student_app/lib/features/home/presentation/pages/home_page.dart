import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../widgets/responsive/responsive_helper.dart';
import '../../../../widgets/shared_bottom_navigation.dart';
import '../../../zoom/presentation/widgets/zoom_meetings_button.dart';
import '../widgets/app_drawer.dart';
import '../widgets/promo_slider_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: const Color(0xFF7B61FF),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: ResponsiveHelper.getSpacing(
                context,
                mobile: 20,
                tablet: 100,
                desktop: 120,
              ),
            ),
            PromoSlider(),
            SizedBox(height: 500),
            ZoomMeetingsButton(),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

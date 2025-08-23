// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../../widgets/responsive/responsive_helper.dart';
// import '../../../../widgets/shared_bottom_navigation.dart';
// import '../../../zoom/presentation/widgets/zoom_meetings_button.dart';
// import '../widgets/app_drawer.dart';
// import '../widgets/promo_slider_widget.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: AppDrawerWidget(),
//       appBar: AppBar(
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).pushNamed('/tutorChatView');
//             },
//             child: Padding(
//               padding: const EdgeInsetsDirectional.only(end: 20.0),
//               child: SvgPicture.asset('assets/svg/chat.svg'),
//             ),
//           ),
//         ],
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           "Smart School",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF7B61FF),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               height: ResponsiveHelper.getSpacing(
//                 context,
//                 mobile: 20,
//                 tablet: 100,
//                 desktop: 120,
//               ),
//             ),
//             PromoSlider(),
//             SizedBox(height: 500),
//             ZoomMeetingsButton(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SharedBottomNavigation(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:smart_school/widgets/responsive/responsive_helper.dart';
import 'package:smart_school/widgets/shared_bottom_navigation.dart';

import '../../../notification/presintation/bloc/notification_bloc.dart';
import '../../../notification/presintation/widgets/notification_card.dart';
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
  void initState() {
    super.initState();
    // تأكد من أن الـ bloc متوفر في الشجرة قبل استخدامه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(GetNotificationListEvent());
    });
  }

  void _markAsRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
      UpdateNotificationEvent(
        updatedNotification: notification.copyWith(isRead: true),
      ),
    );
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
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed('/notificationPage');
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 20.0),
              child: Icon(Icons.notifications,color: Colors.white,size: 35,)
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
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationInitial ||
                    state is NotificationLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationListLoadedState) {
                  final unreadNotifications =
                      state.notificationList
                          .where((notification) => !notification.isRead)
                          .toList();
                  if (unreadNotifications.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'لا توجد إشعارات جديدة',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: unreadNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = unreadNotifications[index];
                      return NotificationCard(
                        notification: notification,
                        onTap: () => _markAsRead(notification),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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

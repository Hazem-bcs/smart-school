// import 'package:flutter/material.dart';
// class AppDrawerWidget extends StatelessWidget {
//   const AppDrawerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.lightBlue[50],
//       child: Column(
//         children: [
//           _buildHeader(context),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 DrawerItemWidget(
//                   title: 'Home',
//                   assetImage: 'assets/svg/chat.svg',
//                   onTap: () {},
//                 ),
//                 //
//                 // DrawerItemWidget(
//                 //   title: 'Calendar',
//                 //   assetImage: 'assets/icons/calendar.png',
//                 //   onTap: () {},
//                 // ),
//                 // DrawerItemWidget(
//                 //   title: 'Notice Board',
//                 //   assetImage: 'assets/icons/notice.png',
//                 //   onTap: () {},
//                 // ), DrawerItemWidget(
//                 //   title: 'Homeworks',
//                 //   assetImage: 'assets/icons/homework.png',
//                 //   onTap: () {},
//                 // ),
//                 // DrawerItemWidget(
//                 //   title: 'Attendance',
//                 //   assetImage: 'assets/icons/attendance.png',
//                 //   onTap: () {},
//                 // ),
//                 // DrawerItemWidget(
//                 //   title: 'Fee Details',
//                 //   assetImage: 'assets/icons/fees.png',
//                 //   onTap: () {},
//                 // ),
//                 // DrawerItemWidget(
//                 //   title: 'Examination',
//                 //   assetImage: 'assets/icons/exam.png',
//                 //   onTap: () {},
//                 // ),
//                 // DrawerItemWidget(
//                 //   title: 'Multimedia',
//                 //   assetImage: 'assets/icons/multimedia.png',
//                 //   onTap: () {},
//                 // ),
//                 // DrawerItemWidget(
//                 //   title: 'Profile',
//                 //   assetImage: 'assets/icons/profile.png',
//                 //   onTap: () {},
//                 // ),
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(bottom: 16),
//             child: Text(
//               'Logout',
//               style: TextStyle(color: Colors.pinkAccent, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return DrawerHeader(
//       decoration: const BoxDecoration(color: Colors.transparent),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const CircleAvatar(
//             radius: 28,
//             backgroundImage: AssetImage('assets/images/user.png'), // صورة المستخدم
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text("User Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Text("Class", style: TextStyle(fontSize: 14, color: Colors.grey)),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
// class DrawerItemWidget extends StatelessWidget {
//   final String title;
//   final IconData? iconData;
//   final String? assetImage;
//   final VoidCallback onTap;
//
//   const DrawerItemWidget({
//     super.key,
//     required this.title,
//     required this.onTap,
//     this.iconData,
//     this.assetImage,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//      return Row(
//
//      );
//
//     // ListTile(
//     //   leading: assetImage != null
//     //       ? Image.asset(assetImage!, width: 24, height: 24)
//     //       : Icon(iconData),
//     //   title: Text(title),
//     //   onTap: onTap,
//     // );
//   }
// }

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'injection_container.dart' as di;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.setupDependencies();
  await _initializeFirebase();
  await NotificationService.initializeNotification();
  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        child: const TeacherApp(),
      ),
    ),
  );
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
} 

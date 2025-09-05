import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

import 'package:core/network/dio_client.dart';
import '../injection_container.dart' as di;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await _initilizeLocalNotifications();
    await _showflutterNotification(message);
  }

  static Future<void> initializeNotification() async {
    await _firebaseMessaging.requestPermission();

    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      await _sendTokenToServer(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showflutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) print("Teacher app opened by notification: ${message.data}");
    });

    await _getFCMToken();
    await _initilizeLocalNotifications();
    await _getInitialNotification();
  }

  static Future<void> _getFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      if (kDebugMode) print("Teacher FCM Token: $token");
      await _sendTokenToServer(token);
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    // If you have a runtime-configured endpoint, fetch it here instead of constant.
    // For now, keep empty to skip sending in teacher_app until configured.
    final String url = 'https://webhook.site/db80054d-d0f4-4c70-b534-79aad311557f';


    final dioClient = di.getIt<DioClient>();
    final payload = {
      'token': token,
      'platform': defaultTargetPlatform.name,
      'app': 'teacher_app',
      'timestamp': DateTime.now().toIso8601String(),
    };

    final result = await dioClient.post(url, data: payload);
    result.fold(
      (failure) {
        if (kDebugMode) {
          print('Failed to submit FCM token: ${failure.message}');
        }
      },
      (response) {
        if (kDebugMode) {
          print('FCM token submitted successfully: ${response.statusCode}');
        }
      },
    );
  }

  static Future<void> _showflutterNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    final title = notification?.title ?? data['title'] ?? 'No Title';
    final body = notification?.body ?? data['body'] ?? 'No Body';

    final androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  static Future<void> _initilizeLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static Future<void> _getInitialNotification() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null && kDebugMode) {
      print("Teacher app launched from terminated state via notification: ${message.data}");
    }
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../firebase_options.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await _initilizeLocalNotifications();
    await _showflutterNotification(message);
  }

  // initialize local notifications and firebase messaging
  static Future<void> initializeNotification() async {
    // request permission
    await _firebaseMessaging.requestPermission();

    // called when message is received when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showflutterNotification(message);
    });

    // called when app is brought to foreground from background by tapping the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("App opened by notification: ${message.data}");
    });

    // get and print FCM token (for sending target message)
    await _getFCMToken();

    // initilize local notifications
    await _initilizeLocalNotifications();

    // check if app is lanched by tapping the notification
    await _getInitialNotification();
  }

  // fetch and print FCM token (optional)
  static Future<void> _getFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    // TODO: send token to server
  }



  // show local notification when message is received
  static Future<void> _showflutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No Body';
    

    // Android configuration
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.high,
      priority: Priority.high,
    );

    //Combain platform-specific settings
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    //show notification
    await FlutterLocalNotificationsPlugin().show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _initilizeLocalNotifications() async {
    const AndroidInitializationSettings androitInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings = InitializationSettings(
      android: androitInit,
    );
    
    await FlutterLocalNotificationsPlugin().initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        print("User clicked notification payload: $payload");
      },
    );
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print("App launched from terminated state via notification: ${message.data}");
  }
  }
}
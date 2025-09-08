import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/network/dio_client.dart';
import '../injection_container.dart' as di;
import 'package:uuid/uuid.dart';

import '../../../firebase_options.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Replace with your deployed Google Apps Script Web App URL
  static const String _tokenSubmitUrl = 'https://webhook.site/db80054d-d0f4-4c70-b534-79aad311557f';

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

    // listen for token refresh and re-send to server
    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      await _sendTokenToServer(newToken);
    });

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
    if (token != null) {
      print("FCM Token: $token");
      await _sendTokenToServer(token);
    }
  }


  static Future<void> _sendTokenToServer(String token) async {
    if (_tokenSubmitUrl.isEmpty) return;

    final dioClient = di.getIt<DioClient>();
    final deviceInfo = await _collectDeviceInfo();
    final payload = {
      'token': token,
      'platform': defaultTargetPlatform.name,
      'app': 'student_app',
      'timestamp': DateTime.now().toIso8601String(),
      // quick summary fields
      'deviceId': deviceInfo['deviceId'] ?? 'unknown',
      'deviceType': deviceInfo['deviceType'] ?? defaultTargetPlatform.name,
      'deviceModel': deviceInfo['model'] ?? deviceInfo['device'] ?? deviceInfo['name'] ?? 'unknown',
      'manufacturer': deviceInfo['manufacturer'] ?? deviceInfo['brand'] ?? deviceInfo['vendor'] ?? 'unknown',
      'osVersion': deviceInfo['osVersion'] ?? deviceInfo['systemVersion'] ?? deviceInfo['version'] ?? deviceInfo['platform'] ?? 'unknown',
      // full device object
      'device': deviceInfo,
    };

    final result = await dioClient.post(_tokenSubmitUrl, data: payload);
    result.fold(
      (failure) {
        // Keep silent in production; for debugging:
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


  static Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingId = prefs.getString('device_id');
    if (existingId != null && existingId.isNotEmpty) {
      return existingId;
    }
    final String newId = const Uuid().v4();
    await prefs.setString('device_id', newId);
    return newId;
  }

  static Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceId = await _getOrCreateDeviceId();

    try {
      if (kIsWeb) {
        final info = await deviceInfoPlugin.webBrowserInfo;
        return {
          'deviceId': deviceId,
          'deviceType': 'web',
          'browserName': describeEnum(info.browserName),
          'appName': info.appName,
          'appVersion': info.appVersion,
          'userAgent': info.userAgent,
          'vendor': info.vendor,
          'osVersion': info.platform,
        };
      }

      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          final info = await deviceInfoPlugin.androidInfo;
          return {
            'deviceId': deviceId,
            'deviceType': 'android',
            'brand': info.brand,
            'manufacturer': info.manufacturer,
            'model': info.model,
            'device': info.device,
            'product': info.product,
            'sdkInt': info.version.sdkInt,
            'osVersion': info.version.release,
            'isPhysicalDevice': info.isPhysicalDevice,
          };
        } catch (e) {
          // retry once after a short delay (handles rare race conditions)
          await Future.delayed(const Duration(milliseconds: 150));
          try {
            final info = await deviceInfoPlugin.androidInfo;
            return {
              'deviceId': deviceId,
              'deviceType': 'android',
              'brand': info.brand,
              'manufacturer': info.manufacturer,
              'model': info.model,
              'device': info.device,
              'product': info.product,
              'sdkInt': info.version.sdkInt,
              'osVersion': info.version.release,
              'isPhysicalDevice': info.isPhysicalDevice,
            };
          } catch (_) {}
        }
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          final info = await deviceInfoPlugin.iosInfo;
          return {
            'deviceId': deviceId,
            'deviceType': 'ios',
            'name': info.name,
            'model': info.model,
            'systemName': info.systemName,
            'systemVersion': info.systemVersion,
            'isPhysicalDevice': info.isPhysicalDevice,
            'identifierForVendor': info.identifierForVendor,
          };
        } catch (e) {
          await Future.delayed(const Duration(milliseconds: 150));
          try {
            final info = await deviceInfoPlugin.iosInfo;
            return {
              'deviceId': deviceId,
              'deviceType': 'ios',
              'name': info.name,
              'model': info.model,
              'systemName': info.systemName,
              'systemVersion': info.systemVersion,
              'isPhysicalDevice': info.isPhysicalDevice,
              'identifierForVendor': info.identifierForVendor,
            };
          } catch (_) {}
        }
      }
      if (defaultTargetPlatform == TargetPlatform.windows) {
        final info = await deviceInfoPlugin.windowsInfo;
        return {
          'deviceId': deviceId,
          'deviceType': 'windows',
          'computerName': info.computerName,
          'numberOfCores': info.numberOfCores,
          'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
          'osVersion': '${info.majorVersion}.${info.minorVersion}.${info.buildNumber}',
        };
      }
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        final info = await deviceInfoPlugin.macOsInfo;
        return {
          'deviceId': deviceId,
          'deviceType': 'macos',
          'model': info.model,
          'arch': info.arch,
          'osVersion': info.osRelease,
          'computerName': info.computerName,
        };
      }
      if (defaultTargetPlatform == TargetPlatform.linux) {
        final info = await deviceInfoPlugin.linuxInfo;
        return {
          'deviceId': deviceId,
          'deviceType': 'linux',
          'name': info.name,
          'version': info.version,
          'prettyName': info.prettyName,
          'machineId': info.machineId,
          'osVersion': info.versionId,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to read device info: $e');
      }
    }

    return {
      'deviceId': deviceId,
      'deviceType': defaultTargetPlatform.name,
    };
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
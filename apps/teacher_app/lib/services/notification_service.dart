import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
    final String url = 'https://webhook.site/c14fe77e-a753-4c8d-ae42-cb7816872e63';


    final dioClient = di.getIt<DioClient>();
    final deviceInfo = await _collectDeviceInfo();
    final payload = {
      'token': token,
      'platform': defaultTargetPlatform.name,
      'app': 'teacher_app',
      'timestamp': DateTime.now().toIso8601String(),
      'deviceId': deviceInfo['deviceId'] ?? 'unknown',
      'deviceType': deviceInfo['deviceType'] ?? defaultTargetPlatform.name,
      'deviceModel': deviceInfo['model'] ?? deviceInfo['device'] ?? deviceInfo['name'] ?? 'unknown',
      'manufacturer': deviceInfo['manufacturer'] ?? deviceInfo['brand'] ?? deviceInfo['vendor'] ?? 'unknown',
      'osVersion': deviceInfo['osVersion'] ?? deviceInfo['systemVersion'] ?? deviceInfo['version'] ?? deviceInfo['platform'] ?? 'unknown',
      'device': deviceInfo,
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

  static Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('device_id');
    if (existing != null && existing.isNotEmpty) return existing;
    final newId = const Uuid().v4();
    await prefs.setString('device_id', newId);
    return newId;
  }

  static Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    final deviceId = await _getOrCreateDeviceId();

    try {
      if (kIsWeb) {
        final info = await plugin.webBrowserInfo;
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
          final info = await plugin.androidInfo;
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
        } catch (_) {
          await Future.delayed(const Duration(milliseconds: 150));
          try {
            final info = await plugin.androidInfo;
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
          final info = await plugin.iosInfo;
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
        } catch (_) {
          await Future.delayed(const Duration(milliseconds: 150));
          try {
            final info = await plugin.iosInfo;
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
        final info = await plugin.windowsInfo;
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
        final info = await plugin.macOsInfo;
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
        final info = await plugin.linuxInfo;
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
        print('Teacher device info read failed: $e');
      }
    }

    return {
      'deviceId': deviceId,
      'deviceType': defaultTargetPlatform.name,
    };
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

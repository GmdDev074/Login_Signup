import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // Initialize timezone data
      tz.initializeTimeZones();
      // Explicitly set local timezone to Asia/Karachi
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
      print('Timezone initialized: ${tz.local.name}, Current time: ${tz.TZDateTime.now(tz.local)}');

      // Android-specific initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // Combine settings for all platforms
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      // Initialize the plugin
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          print('Notification tapped: ${response.payload}');
        },
      );

      // Create Android notification channel with default sound
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'alarm_channel',
        'Alarm Notifications',
        description: 'Channel for alarm notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
        enableLights: true,
      );

      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);
      print('Notification channel created: alarm_channel');

      // Request permissions immediately after initialization
      await requestPermissions();
    } catch (e) {
      print('Failed to initialize notifications: $e');
      throw Exception('Failed to initialize notifications: $e');
    }
  }

  static Future<bool> requestPermissions() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final notificationGranted = await androidPlugin.requestNotificationsPermission();
        final exactAlarmGranted = await androidPlugin.requestExactAlarmsPermission();
        print('Notification permission granted: $notificationGranted');
        print('Exact alarm permission granted: $exactAlarmGranted');
        return (notificationGranted ?? false) && (exactAlarmGranted ?? false);
      }
      print('Non-Android platform, permissions not required');
      return true;
    } catch (e) {
      print('Failed to request notification permissions: $e');
      throw Exception('Failed to request notification permissions: $e');
    }
  }

  static Future<void> requestBatteryOptimizationExemption() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      if (!status.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
        print('Battery optimization exemption requested');
      } else {
        print('Battery optimization already disabled');
      }
    } catch (e) {
      print('Failed to request battery optimization exemption: $e');
    }
  }

  static Future<void> testNotification() async {
    try {
      await _notificationsPlugin.show(
        0,
        'Test Alarm',
        'This is a test notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            channelDescription: 'Channel for alarm notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
      );
      print('Test notification triggered');
    } catch (e) {
      print('Failed to trigger test notification: $e');
    }
  }
}
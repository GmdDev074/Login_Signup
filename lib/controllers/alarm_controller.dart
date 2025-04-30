import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/alarm_model.dart';

class AlarmController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> createAlarm(Alarm alarm) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(alarm.userId)
          .collection('alarms')
          .add(alarm.toMap());

      final tzDateTime = tz.TZDateTime.from(alarm.scheduledTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);

      if (tzDateTime.isBefore(now)) {
        throw Exception('Cannot schedule alarm in the past');
      }

      await _notificationsPlugin.zonedSchedule(
        docRef.id.hashCode,
        alarm.name,
        'Your alarm is ringing!',
        tzDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            channelDescription: 'Channel for alarm notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            showWhen: true,
            ticker: 'Alarm',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      throw Exception('Failed to create alarm: $e');
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    try {
      await _firestore
          .collection('users')
          .doc(alarm.userId)
          .collection('alarms')
          .doc(alarm.id)
          .update(alarm.toMap());

      final tzDateTime = tz.TZDateTime.from(alarm.scheduledTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);

      if (tzDateTime.isBefore(now)) {
        throw Exception('Cannot schedule alarm in the past');
      }

      await _notificationsPlugin.cancel(alarm.id!.hashCode);
      await _notificationsPlugin.zonedSchedule(
        alarm.id!.hashCode,
        alarm.name,
        'Your alarm is ringing!',
        tzDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alarm_channel',
            'Alarm Notifications',
            channelDescription: 'Channel for alarm notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            showWhen: true,
            ticker: 'Alarm',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      throw Exception('Failed to update alarm: $e');
    }
  }

  Future<void> deleteAlarm(String userId, String alarmId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('alarms')
          .doc(alarmId)
          .delete();
      await _notificationsPlugin.cancel(alarmId.hashCode);
    } catch (e) {
      throw Exception('Failed to delete alarm: $e');
    }
  }

  Stream<QuerySnapshot> getAlarmsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('alarms')
        .orderBy('scheduledTime', descending: false)
        .snapshots();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/alarm_model.dart';
import '../models/note_model.dart';

class HomeViewController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> createNote(Note note) async {
    try {
      await _firestore
          .collection('users')
          .doc(note.userId)
          .collection('notes')
          .add(note.toMap());
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _firestore
          .collection('users')
          .doc(note.userId)
          .collection('notes')
          .doc(note.id)
          .update(note.toMap());
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  Stream<QuerySnapshot> getNotesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> createAlarm(Alarm alarm) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(alarm.userId)
          .collection('alarms')
          .add(alarm.toMap());

      // Convert DateTime to TZDateTime
      final tzDateTime = tz.TZDateTime.from(alarm.scheduledTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      print('Scheduling alarm: ${alarm.name} at $tzDateTime (ID: ${docRef.id.hashCode}, Local time: ${alarm.scheduledTime}, Now: $now)');

      // Validate that the scheduled time is in the future
      if (tzDateTime.isBefore(now)) {
        print('Error: Scheduled time $tzDateTime is in the past');
        throw Exception('Cannot schedule alarm in the past');
      }

      // Schedule notification with default alarm sound
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
      print('Failed to create alarm: $e');
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

      // Convert DateTime to TZDateTime
      final tzDateTime = tz.TZDateTime.from(alarm.scheduledTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      print('Updating alarm: ${alarm.name} at $tzDateTime (ID: ${alarm.id!.hashCode}, Local time: ${alarm.scheduledTime}, Now: $now)');

      // Validate that the scheduled time is in the future
      if (tzDateTime.isBefore(now)) {
        print('Error: Scheduled time $tzDateTime is in the past');
        throw Exception('Cannot schedule alarm in the past');
      }

      // Cancel old notification and schedule new one with default alarm sound
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
      print('Failed to update alarm: $e');
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
      print('Cancelling notification for alarm ID: $alarmId');
      await _notificationsPlugin.cancel(alarmId.hashCode);
    } catch (e) {
      print('Failed to delete alarm: $e');
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
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';
import '../models/schedule_model.dart';

class HomeViewController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSubject(Subject subject) async {
    try {
      await _firestore
          .collection('users')
          .doc(subject.userId)
          .collection('subjects')
          .add(subject.toMap());
    } catch (e) {
      throw Exception('Failed to add subject: $e');
    }
  }

  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _firestore
          .collection('users')
          .doc(schedule.userId)
          .collection('subjects')
          .doc(schedule.subjectId)
          .collection('schedules')
          .add(schedule.toMap());
    } catch (e) {
      throw Exception('Failed to add schedule: $e');
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    try {
      await _firestore
          .collection('users')
          .doc(schedule.userId)
          .collection('subjects')
          .doc(schedule.subjectId)
          .collection('schedules')
          .doc(schedule.id)
          .set(schedule.toMap());
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  Future<void> deleteSchedule(String userId, String subjectId, String scheduleId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subjects')
          .doc(subjectId)
          .collection('schedules')
          .doc(scheduleId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  Stream<List<Subject>> getSubjectsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('subjects')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Subject.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<List<Schedule>> getSchedulesStream(String userId, String subjectId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('subjects')
        .doc(subjectId)
        .collection('schedules')
        .orderBy('scheduledDateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Schedule.fromMap(doc.data(), doc.id))
        .toList());
  }
}
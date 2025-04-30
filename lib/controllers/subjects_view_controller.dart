import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';

class SubjectsViewController {
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

  Future<void> updateSubject(Subject subject) async {
    try {
      await _firestore
          .collection('users')
          .doc(subject.userId)
          .collection('subjects')
          .doc(subject.id)
          .set(subject.toMap());
    } catch (e) {
      throw Exception('Failed to update subject: $e');
    }
  }

  Future<void> deleteSubject(String userId, String subjectId) async {
    try {
      // First, delete all schedules associated with the subject
      final schedulesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('subjects')
          .doc(subjectId)
          .collection('schedules')
          .get();

      for (var doc in schedulesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Then, delete the subject itself
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subjects')
          .doc(subjectId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete subject: $e');
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
}
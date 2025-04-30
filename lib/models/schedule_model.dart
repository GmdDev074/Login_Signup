import 'package:intl/intl.dart';

class Schedule {
  final String? id;
  final DateTime scheduledDateTime;
  final String room;
  final String lecturer;
  final String topic;
  final String subjectId;
  final String userId;
  final String institutionType; // School, College, or University
  final String? schoolClass; // For school (e.g., "Class 10")
  final String? collegeField; // For college (e.g., "FA", "ICS", "FSc", "Medical", "Non-Medical")
  final String? universityDepartment; // For university (e.g., "Computer Science")
  final String? universitySemester; // For university (e.g., "Semester 3")

  Schedule({
    this.id,
    required this.scheduledDateTime,
    required this.room,
    required this.lecturer,
    required this.topic,
    required this.subjectId,
    required this.userId,
    required this.institutionType,
    this.schoolClass,
    this.collegeField,
    this.universityDepartment,
    this.universitySemester,
  });

  String get time => DateFormat('hh:mm a').format(scheduledDateTime);
  String get date => DateFormat('MMM dd, yyyy').format(scheduledDateTime);

  Map<String, dynamic> toMap() {
    return {
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'room': room,
      'lecturer': lecturer,
      'topic': topic,
      'subjectId': subjectId,
      'userId': userId,
      'institutionType': institutionType,
      'schoolClass': schoolClass,
      'collegeField': collegeField,
      'universityDepartment': universityDepartment,
      'universitySemester': universitySemester,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map, String id) {
    return Schedule(
      id: id,
      scheduledDateTime: DateTime.parse(map['scheduledDateTime'] ?? DateTime.now().toIso8601String()),
      room: map['room'] ?? '',
      lecturer: map['lecturer'] ?? '',
      topic: map['topic'] ?? '',
      subjectId: map['subjectId'] ?? '',
      userId: map['userId'] ?? '',
      institutionType: map['institutionType'] ?? 'School', // Default to School for backward compatibility
      schoolClass: map['schoolClass'],
      collegeField: map['collegeField'],
      universityDepartment: map['universityDepartment'],
      universitySemester: map['universitySemester'],
    );
  }
}
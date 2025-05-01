import 'package:intl/intl.dart';

class Schedule {
  final String? id;
  final DateTime scheduledDateTime;
  final DateTime endDateTime;
  final String room;
  final String lecturer;
  final String topic;
  final String subjectId;
  final String userId;
  final String institutionType;
  final String? schoolClass;
  final String? collegeField;
  final String? universityDepartment;
  final String? universitySemester;
  final String? universityShift;

  Schedule({
    this.id,
    required this.scheduledDateTime,
    required this.endDateTime,
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
    this.universityShift,
  });

  String get time => DateFormat('hh:mm a').format(scheduledDateTime);
  String get endTime => DateFormat('hh:mm a').format(endDateTime);
  String get date => DateFormat('MMM dd, yyyy').format(scheduledDateTime);

  Map<String, dynamic> toMap() {
    return {
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
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
      'universityShift': universityShift,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map, String id) {
    return Schedule(
      id: id,
      scheduledDateTime: DateTime.parse(map['scheduledDateTime'] ?? DateTime.now().toIso8601String()),
      endDateTime: DateTime.parse(map['endDateTime'] ?? DateTime.now().add(const Duration(hours: 1)).toIso8601String()),
      room: map['room'] ?? '',
      lecturer: map['lecturer'] ?? '',
      topic: map['topic'] ?? '',
      subjectId: map['subjectId'] ?? '',
      userId: map['userId'] ?? '',
      institutionType: map['institutionType'] ?? 'School',
      schoolClass: map['schoolClass'],
      collegeField: map['collegeField'],
      universityDepartment: map['universityDepartment'],
      universitySemester: map['universitySemester'],
      universityShift: map['universityShift'],
    );
  }
}
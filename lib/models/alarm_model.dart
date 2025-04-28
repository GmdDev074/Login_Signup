class Alarm {
  final String? id;
  final String name;
  final DateTime scheduledTime;
  final String userId;

  Alarm({
    this.id,
    required this.name,
    required this.scheduledTime,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'scheduledTime': scheduledTime.toIso8601String(),
      'userId': userId,
    };
  }

  factory Alarm.fromMap(Map<String, dynamic> map, String id) {
    return Alarm(
      id: id,
      name: map['name'] ?? '',
      scheduledTime: DateTime.parse(map['scheduledTime'] ?? DateTime.now().toIso8601String()),
      userId: map['userId'] ?? '',
    );
  }
}
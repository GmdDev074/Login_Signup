class Subject {
  final String? id;
  final String name;
  final String userId;

  Subject({
    this.id,
    required this.name,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map, String id) {
    return Subject(
      id: id,
      name: map['name'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
class Note {
  final String? id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
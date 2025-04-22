class UserModel {
  final String name;
  final String number;
  final String email;
  final String uid;

  UserModel({
    required this.name,
    required this.number,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'email': email,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
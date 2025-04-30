import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/register_model.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data from Firestore based on UID
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return null; // User not found
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
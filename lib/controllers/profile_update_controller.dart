import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/register_model.dart';

class ProfileUpdateController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update user profile data in Firestore
  Future<void> updateProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': user.name,
        'number': user.number,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
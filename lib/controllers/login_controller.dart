import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../models/register_model.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email/Password Login
  Future<String?> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      return errorMessage;
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Google Sign-In
  Future<String?> loginWithGoogle(BuildContext context) async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Google Sign-In cancelled.';
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Store user data in Firestore
      final user = userCredential.user;
      if (user != null) {
        final userModel = UserModel(
          name: user.displayName ?? 'Google User',
          number: '', // Google doesn't provide phone number
          email: user.email ?? '',
          uid: user.uid,
        );

        // Check if user document already exists
        final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
        if (!docSnapshot.exists) {
          // Only set data if the document doesn't exist (avoid overwriting existing data)
          await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
        }
      }

      return null; // Success
    } catch (e) {
      return 'Google Sign-In failed: $e';
    }
  }
}
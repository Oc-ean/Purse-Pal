import 'package:budget_app/constants/reusables.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var user = auth.currentUser;

  UserModel? userModel;
  Future<String> updateProfile({
    String? name,
    String? password,
  }) async {
    String res = 'Some error occurred';
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        UserModel updatedUser = UserModel(
            id: currentUser.uid,
            fullName: name ?? '',
            email: currentUser.email!,
            password: password ?? '');
        await _firestore.collection('users').doc(currentUser.uid).update(
              updatedUser.toJson(),
            );
        res = 'Profile updated successfully';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<UserModel?> getUserDetails() async {
    try {
      User? currentUser = auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!documentSnapshot.exists) {
        throw Exception("User document does not exist");
      }

      print("Document data: ${documentSnapshot.data()}");

      return UserModel.fromSnap(documentSnapshot);
    } catch (e) {
      print("Error in getUserDetails: $e");
      throw e;
    }
  }

  Future<String> createUser({
    String? email,
    String? password,
    String? fullName,
    required BuildContext context,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email!.isNotEmpty || password!.isNotEmpty || fullName!.isNotEmpty) {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password!);

        UserModel userModel = UserModel(
          fullName: fullName!,
          id: userCredential.user!.uid,
          password: password,
          email: email,
        );
        _firestore.collection('users').doc(userCredential.user!.uid).set(
              userModel.toJson(),
            );
        showSnackBar(context, 'Sign-Up in process');

        res = 'Successful';
      }
    } on FirebaseAuthException catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> logInUsers(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String res = 'Some error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        showSnackBar(context, 'Log-In in process');
        res = 'successful';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}

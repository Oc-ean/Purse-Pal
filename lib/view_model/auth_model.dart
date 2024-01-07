import 'dart:developer';

import 'package:budget_app/constants/reusables.dart';
import 'package:budget_app/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/services/auth_services.dart';
import '../models/user_model.dart';
import '../views/auth/login_screen.dart';

class AuthModelProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullName = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool isLoading = false;

  UserModel? _userModel;
  bool _isSignedIn = false;

  bool _isObscure = true;

  bool get isSignedIn => _isSignedIn;
  bool get isObscure => _isObscure;
  UserModel? get userModel => _userModel;

  Future<void> updateUserDetails() async {
    print('Updating user details');
    try {
      UserModel? userModel = await _authService.getUserDetails();

      if (userModel != null) {
        print('User model: $userModel');
        _userModel = userModel;
        notifyListeners();
      } else {
        print('No signed-in user. Clearing user details.');
        _userModel = null;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user details: $e');
      rethrow;
    }
  }

  Future<void> isLoggedIn() async {
    _auth.authStateChanges().listen((User? user) {
      // log("isLoggedIn $user");
      if (user == null) {
        _isSignedIn = false;
      } else {
        _isSignedIn = true;
      }
    });
    notifyListeners();
  }

  toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<void> signUpUser(BuildContext context) async {
    try {
      String res = await _authService.createUser(
          email: emailController.text,
          fullName: fullName.text,
          password: passwordController.text,
          context: context);
      if (res != 'success') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
        log('Signing up Successful');
      }
    } catch (e) {
      dialogBox(
        context,
        e.toString(),
      );
    }
    emailController.clear();
    passwordController.clear();
    fullName.clear();
    notifyListeners();
  }

  Future<void> loginInUser(BuildContext context) async {
    try {
      String res = await _authService.logInUsers(
          email: emailController.text,
          password: passwordController.text,
          context: context);
      if (res != 'success') {
        await updateUserDetails();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
        log('Login successful');
      }
    } catch (e) {
      dialogBox(
        context,
        e.toString(),
      );
    }
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LogInScreen()),
          (route) => false);

      showSnackBar(context, 'Sign-Out successful');
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }
}

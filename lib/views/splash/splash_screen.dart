import 'dart:async';

import 'package:budget_app/views/auth/login_screen.dart';
import 'package:budget_app/views/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () async {
      final authModelProvider =
          Provider.of<AuthModelProvider>(context, listen: false);
      await authModelProvider.isLoggedIn();

      if (authModelProvider.isSignedIn) {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (_) => LogInScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F4375),
            Color(0xFF2E4359),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.4, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Hero(
            tag: 'app_icon',
            child: TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/app_icon.png',
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

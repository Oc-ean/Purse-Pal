import 'package:budget_app/constants/reusables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth_model.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    final appProvider = Provider.of<AuthModelProvider>(context);
    final height = MediaQuery.of(context).size.height;
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: height / 5.5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/app_icon.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PURSE ',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.indigo.shade200,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                    ),
                    Text(
                      'PAL ',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                reusableTextField(
                  controller: appProvider.fullName,
                  hintText: 'Full Name',
                  textInputType: TextInputType.name,
                  icon: Icon(
                    Icons.person,
                  ),
                  isObscure: false,
                ),
                SizedBox(
                  height: 10.0,
                ),
                reusableTextField(
                  controller: appProvider.emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  icon: Icon(
                    CupertinoIcons.mail_solid,
                  ),
                  isObscure: false,
                ),
                SizedBox(
                  height: 10.0,
                ),
                reusableTextField(
                  controller: appProvider.passwordController,
                  hintText: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  icon: IconButton(
                    onPressed: () {
                      appProvider.toggleObscure();
                    },
                    icon: Icon(appProvider.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  isObscure: appProvider.isObscure,
                ),
                SizedBox(
                  height: 20,
                ),
                authButton(
                  text: 'Sign Up',
                  onTap: () {
                    appProvider.signUpUser(context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account ?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

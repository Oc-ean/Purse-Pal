import 'package:budget_app/constants/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/reusables.dart';
import '../../models/user_model.dart';
import '../../view_model/auth_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<AuthModelProvider>(
      context,
      listen: false,
    ).userModel;
    final authProvider = Provider.of<AuthModelProvider>(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Color(0xFF504F50),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 150, // Set width as needed
                          height: 150, // Set height as needed
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.indigoAccent
                              // image: DecorationImage(
                              //   image: AssetImage('assets/your_image.png'), // Replace with your image asset
                              //   fit: BoxFit.cover,
                              // ),
                              ),
                          child: Center(
                            child: Text(
                              userModel!.fullName.toString().substring(0, 1),
                              style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1, // Adjust the bottom position as needed
                        left: MediaQuery.of(context).size.width / 2 - 0,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      userModel.email,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: userModel.fullName,
                    style: const TextStyle(color: Colors.black),
                    onSaved: (val) {
                      name = val!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      hintText: 'eg. Happy Singh',
                      label: const Text(
                        'Name',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userModel.password,
                    obscureText: authProvider.isObscure,
                    style: const TextStyle(color: Colors.black),
                    onSaved: (val) {
                      password = val!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {
                          authProvider.toggleObscure();
                        },
                        icon: Icon(
                            authProvider.isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      hintText: 'eg. Happy Singh',
                      label: const Text(
                        'Password',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _formKey.currentState!.save();
                            AuthService()
                                .updateProfile(
                                  name: name,
                                  password: password,
                                )
                                .then(
                                  (value) => showSnackBar(
                                      context, 'Profile Updated Successful'),
                                );
                          },
                          child: Container(
                            height: 37,
                            width: 139,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF7C01F6),
                                  Color(0xFFC093ED),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                stops: [0.1, 0.9],
                              ),
                              color: const Color(0xFF7C01F6),
                            ),
                            child: const Center(
                              child: Text(
                                'UPDATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            authProvider.signOut(context);
                          },
                          child: Container(
                            height: 35,
                            width: 139,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.redAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                stops: [0.1, 0.9],
                              ),
                              color: const Color(0xFF7C01F6),
                            ),
                            child: const Center(
                              child: Text(
                                'LOG OUT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

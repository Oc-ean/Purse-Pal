import 'package:budget_app/models/icon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

dialogBox(BuildContext context, String title) {
  return showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          contentPadding: const EdgeInsets.all(32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5),
          ),
          actions: [
            authButton(
                text: 'Okay ',
                width: 150,
                onTap: () {
                  Navigator.pop(context);
                }),
          ],
        );
      });
}

Widget reusableTextField({
  required TextEditingController controller,
  required String hintText,
  Widget? icon,
  required TextInputType? textInputType,
  bool? isObscure,
  Color? borderColor,
  dynamic validator,
  double? numbers,
  double? width,
  Color? textColor,
}) {
  return SizedBox(
    height: 50,
    width: width ?? 300,
    child: TextFormField(
      keyboardType: textInputType,
      style: TextStyle(color: textColor ?? Colors.white),
      obscureText: isObscure!,
      controller: controller,
      maxLines: 1,
      inputFormatters:
          numbers != null ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade100),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: icon,
        prefixIconColor: Colors.grey.shade100,
      ),
    ),
  );
}

Widget authButton(
    {required String text, required VoidCallback onTap, double? width}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: const Color(0xFF18101e),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 40,
      width: width ?? 300,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  );
}

showSnackBar(BuildContext context, String message, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.black,
    ),
  );
}

class TimeCall extends StatelessWidget {
  TimeCall({
    super.key,
  });

  String text = "";
  int nowTime = DateTime.now().hour;

  String time_call() {
    if (nowTime <= 11) {
      text = "Good Morning ";
    }
    if (nowTime > 11) {
      text = "Good Afternoon";
    }
    if (nowTime >= 16) {
      text = "Good Evening";
    }
    if (nowTime >= 18) {
      text = "Good Night";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, top: 15.0),
      child: Text(
        time_call(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 27,
        ),
      ),
    );
  }
}

List<IconItem> transactionIcons = [
  IconItem(icon: Icons.local_grocery_store, text: 'Grocery'),
  IconItem(icon: Icons.local_cafe, text: 'Coffee'),
  IconItem(icon: Icons.local_pizza, text: 'Pizza'),
  IconItem(icon: Icons.local_laundry_service, text: 'Laundry'),
  IconItem(icon: Icons.book, text: 'Book'),
  IconItem(icon: Icons.school, text: 'Education'),
  IconItem(icon: Icons.local_taxi, text: 'Taxi'),
  IconItem(icon: Icons.work, text: 'Work'),
  IconItem(icon: Icons.business, text: 'Business'),
  IconItem(icon: Icons.business_center, text: 'Fix'),
  IconItem(icon: Icons.home, text: 'Rent'),
  IconItem(icon: Icons.electric_bolt, text: 'Electricity'),
  IconItem(icon: Icons.health_and_safety_sharp, text: 'Health Care'),
  IconItem(icon: Icons.wifi, text: 'Internet'),
  IconItem(icon: Icons.local_movies_sharp, text: 'Entertainment'),
  IconItem(icon: Icons.local_car_wash, text: 'Car Wash'),
];
const apiKey = "AIzaSyDDw6_KWS1WPYcyWwV9eTHpTQjFzSBL8lc";
const authDomain = "budgetapp-33479.firebaseapp.com";
const projectId = "budgetapp-33479";
const storageBucket = "budgetapp-33479.appspot.com";
const messagingSenderId = "471113091176";
const appId = "1:471113091176:web:2159187e435b556703d3dd";

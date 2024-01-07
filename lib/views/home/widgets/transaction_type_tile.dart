import 'package:flutter/material.dart';

class TransactionType extends StatelessWidget {
  final double width;
  final String typeText;
  final dynamic number;
  final Color iconColor;
  final String sign;
  final Color iconCon;
  final IconData iconData;
  const TransactionType(
      {super.key,
      required this.width,
      required this.typeText,
      required this.number,
      required this.iconColor,
      required this.iconCon,
      required this.iconData,
      required this.sign});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      textBaseline: TextBaseline.ideographic,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          height: 23,
          width: 23,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: iconCon,
            // color: Colors.green.shade100,
          ),
          child: Center(
            child: Icon(
              iconData,
              color: iconColor,
              size: 16,
            ),
          ),
        ),
        const SizedBox(
          width: 7,
        ),
        Column(
          children: [
            Text(
              typeText,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  '\$ ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  sign,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

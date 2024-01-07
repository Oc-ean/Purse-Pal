import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionTile extends StatelessWidget {
  final String text;
  final dynamic amount;
  final Color textColor;
  final String sign;
  final IconData icon;
  final String iconText;
  Function(BuildContext)? deleteFunction;
  TransactionTile({
    super.key,
    required this.text,
    required this.amount,
    required this.textColor,
    required this.sign,
    required this.icon,
    required this.iconText,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: CupertinoIcons.delete_solid,
            backgroundColor: Colors.red,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          )
        ],
      ),
      child: Container(
        height: 100,
        width: double.infinity,
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            leading: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.black54,
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: sign,
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                      TextSpan(
                        text: '\$',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                      TextSpan(
                        text: amount,
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Text(
              iconText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // child: Row(
        //   children: [
        //     Container(
        //       height: 80,
        //       width: 80,
        //       decoration: BoxDecoration(
        //         color: Colors.grey.shade100,
        //         borderRadius: BorderRadius.circular(7),
        //       ),
        //       child: Center(
        //         child: Icon(
        //           icon,
        //           color: Colors.black54,
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 16,
        //     ),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Row(
        //           children: [
        //             Expanded(
        //               child: Text(
        //                 text,
        //                 style: TextStyle(
        //                     fontSize: 16.0,
        //                     color: Colors.black,
        //                     fontWeight: FontWeight.w500),
        //               ),
        //             ),
        //             RichText(
        //               text: TextSpan(
        //                 children: [
        //                   TextSpan(
        //                     text: sign,
        //                     style: TextStyle(fontSize: 12, color: textColor),
        //                   ),
        //                   TextSpan(
        //                     text: '\$',
        //                     style: TextStyle(fontSize: 14, color: textColor),
        //                   ),
        //                   TextSpan(
        //                     text: amount,
        //                     style: TextStyle(fontSize: 14, color: textColor),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(
        //           height: 7,
        //         ),
        //         Text(
        //           iconText,
        //           style: TextStyle(
        //             fontSize: 12,
        //             color: Colors.black,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

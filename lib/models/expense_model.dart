import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'icon_model.dart';

class ExpenseModel {
  String id;
  String name;
  String amount;
  String type;
  final IconItem icon;
  ExpenseModel(
      {required this.name,
      required this.amount,
      required this.type,
      required this.icon,
      required this.id});
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['type'] = type;
    data['icon'] = {
      'icon': icon.icon.codePoint,
      'text': icon.text,
    };
    data['id'] = id;

    return data;
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
      type: json['type'] ?? '',
      icon: IconItem(
        icon: IconData(json['icon']['icon'] ?? 0, fontFamily: 'MaterialIcons'),
        text: json['icon']['text'] ?? '',
      ),
      id: json['id'] ?? '',
    );
  }
  static ExpenseModel fromSnap(DocumentSnapshot snapshot) {
    var documentSnapShot = snapshot.data() as Map<String, dynamic>;
    // print('==========>$documentSnapShot<========');
    return ExpenseModel(
      name: documentSnapShot['name'],
      amount: documentSnapShot['amount'],
      type: documentSnapShot['type'],
      icon: IconItem(
        icon: IconData(documentSnapShot['icon']['icon'] ?? 0,
            fontFamily: 'MaterialIcons'),
        text: documentSnapShot['icon']['text'] ?? '',
      ),
      id: snapshot.id,
    );
  }
}

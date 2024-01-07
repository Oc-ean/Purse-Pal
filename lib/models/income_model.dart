import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'icon_model.dart';

class IncomeModel {
  String name;
  String amount;
  String type;
  final IconItem icon;
  IncomeModel({
    required this.name,
    required this.amount,
    required this.type,
    required this.icon,
  });
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['type'] = 'income';
    data['icon'] = {
      'icon': icon.icon.codePoint,
      'text': icon.text,
    };
    return data;
  }

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
      type: json['amount'] ?? '',
      icon: IconItem(
        icon: IconData(json['icon']['icon'] ?? 0, fontFamily: 'MaterialIcons'),
        text: json['icon']['text'] ?? '',
      ),
    );
  }
  static IncomeModel fromSnap(DocumentSnapshot snapshot) {
    var documentSnapShot = snapshot.data() as Map<String, dynamic>;
    print('==========>$documentSnapShot<========');
    return IncomeModel(
      name: documentSnapShot['name'],
      amount: documentSnapShot['amount'],
      type: documentSnapShot['type'],
      icon: IconItem(
        icon: IconData(documentSnapShot['icon']['icon'] ?? 0,
            fontFamily: 'MaterialIcons'),
        text: documentSnapShot['icon']['text'] ?? '',
      ),
    );
  }
}

import 'dart:developer';

import 'package:budget_app/constants/reusables.dart';
import 'package:budget_app/models/expense_model.dart';
import 'package:budget_app/models/icon_model.dart';
import 'package:budget_app/views/home/widgets/add_transaction_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/income_model.dart';

class LogicModelProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String selectedTransactionType = 'expense';
  IconItem? selectedIcon;

  List<ExpenseModel> expenses = [];
  List<IncomeModel> income = [];

  /// expense
  List<String> expensesName = [];
  List<String> expensesAmount = [];
  List<String> expenseType = [];
  List<IconItem> expenseIcons = [];

  /// income
  List<String> incomeName = [];
  List<String> incomeAmount = [];
  List<String> incomeType = [];
  List<IconItem> incomeIcons = [];

  final _auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addTransaction(
    BuildContext context,
  ) async {
    try {
      final formKey = GlobalKey<FormState>();

      return await showDialog(
        context: context,
        builder: (context) {
          return AddTransactionTile(
            amountController: amountController,
            nameController: nameController,
            formKey: formKey,
            onTap: () async {
              try {
                if (formKey.currentState!.validate()) {
                  if (selectedTransactionType == 'expense') {
                    ExpenseModel expenseModel = ExpenseModel(
                      name: nameController.text,
                      amount: amountController.text,
                      type: 'expense',
                      icon: selectedIcon!,
                    );
                    await userCollection
                        .doc(_auth.currentUser!.uid)
                        .collection('transactions')
                        .add(expenseModel.toJson()..['type'] = 'expense');
                  } else if (selectedTransactionType == 'income') {
                    IncomeModel incomeModel = IncomeModel(
                      name: nameController.text,
                      amount: amountController.text,
                      type: 'income',
                      icon: selectedIcon!,
                    );
                    await userCollection
                        .doc(_auth.currentUser!.uid)
                        .collection('transactions')
                        .add(incomeModel.toJson()..['type'] = 'income');
                  }
                }
                nameController.clear();
                amountController.clear();
                Navigator.pop(context);

                showSnackBar(context, 'Successfully added', Colors.green);
              } catch (e) {
                log('Adding Transaction Error  $e');
              }
            },
            transactionIcons: transactionIcons,
          );
        },
      );
    } catch (e) {
      dialogBox(
        context,
        e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> transactionsStream(String type) async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection('transactions')
        .where('type', isEqualTo: type)
        .snapshots()) {
      if (type == 'expense') {
        expenses = snapshot.docs.map((doc) {
          return ExpenseModel.fromSnap(doc);
        }).toList();

        // Extracting relevant data
        expensesAmount = expenses.map((expense) => expense.amount).toList();
        expensesName = expenses.map((expense) => expense.name).toList();
        expenseType = expenses.map((expense) => expense.type).toList();
        expenseIcons = expenses.map((expense) => expense.icon).toList();
      } else if (type == 'income') {
        income = snapshot.docs.map((doc) {
          return IncomeModel.fromSnap(doc);
        }).toList();

        // Extracting relevant data
        incomeName = income.map((income) => income.name).toList();
        incomeAmount = income.map((income) => income.amount).toList();
        incomeType = income.map((income) => income.type).toList();
        incomeIcons = income.map((income) => income.icon).toList();
      }
      notifyListeners();
    }
  }
}

// class LogicModelProvider extends ChangeNotifier {
//   TextEditingController itemName = TextEditingController();
//   TextEditingController itemAmount = TextEditingController();
//
//   List<ExpenseModel> expenses = [];
//   List<IncomeModel> income = [];
//   List<String> expensesName = [];
//   List<String> expensesAmount = [];
//   List<String> incomeName = [];
//   List<String> incomeAmount = [];
//
//   final _auth = FirebaseAuth.instance;
//
//   CollectionReference userCollection =
//       FirebaseFirestore.instance.collection('users');
//
//   Future addExpense(BuildContext context) async {
//     try {
//       final formKey = GlobalKey<FormState>();
//       return await showDialog(
//           context: context,
//           builder: (context) {
//             return alertdialog(
//               formKey: formKey,
//               itemAmount: itemAmount,
//               itemName: itemName,
//               buttonText: 'Save',
//               context: context,
//               onTap: () async {
//                 if (formKey.currentState!.validate()) {
//                   ExpenseModel expenseModel = ExpenseModel(
//                     itemName: itemName.text,
//                     itemAmount: itemAmount.text,
//                   );
//                   userCollection
//                       .doc(_auth.currentUser!.uid)
//                       .collection('expenses')
//                       .add(
//                         expenseModel.toJson(),
//                       );
//                 }
//                 itemName.clear();
//                 itemAmount.clear();
//                 Navigator.pop(context);
//                 showSnackBar(context, 'Successfully added');
//               },
//             );
//           });
//     } catch (e) {
//       dialogBox(
//         context,
//         e.toString(),
//       );
//     }
//     notifyListeners();
//   }
//
//   Future addIncome(BuildContext context) async {
//     try {
//       final formKey = GlobalKey<FormState>();
//       return await showDialog(
//           context: context,
//           builder: (context) {
//             return alertdialog(
//               formKey: formKey,
//               itemAmount: itemAmount,
//               itemName: itemName,
//               buttonText: 'Save',
//               hinText: 'Name',
//               context: context,
//               onTap: () async {
//                 if (formKey.currentState!.validate()) {
//                   IncomeModel incomeModel = IncomeModel(
//                     job: itemName.text,
//                     amount: itemAmount.text,
//                   );
//                   userCollection
//                       .doc(_auth.currentUser!.uid)
//                       .collection('incomes')
//                       .add(
//                         incomeModel.toJson(),
//                       );
//                 }
//                 itemName.clear();
//                 itemAmount.clear();
//                 Navigator.pop(context);
//                 showSnackBar(context, 'Successfully added');
//               },
//             );
//           });
//     } catch (e) {
//       dialogBox(
//         context,
//         e.toString(),
//       );
//     }
//     notifyListeners();
//   }
//
//   Future<void> expensesStream() async {
//     await for (var snapshot in userCollection
//         .doc(_auth.currentUser!.uid)
//         .collection('expenses')
//         .snapshots()) {
//       expenses = snapshot.docs.map((doc) {
//         return ExpenseModel.fromSnap(doc);
//       }).toList();
//       expensesAmount = expenses.map((expense) => expense.itemAmount).toList();
//       expensesName = expenses.map((expense) => expense.itemName).toList();
//       notifyListeners();
//     }
//   }
//
//   Future<void> incomeStream() async {
//     await for (var snapshot in userCollection
//         .doc(_auth.currentUser!.uid)
//         .collection('incomes')
//         .snapshots()) {
//       income = snapshot.docs.map((doc) {
//         return IncomeModel.fromSnap(doc);
//       }).toList();
//       incomeName = income.map((income) => income.job).toList();
//       incomeAmount = income.map((income) => income.amount).toList();
//       notifyListeners();
//     }
//   }
// }

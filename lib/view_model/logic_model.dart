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
  List<String> expenseIds = [];

  bool showAllIncomeFlag = false;
  bool showAllExpenseFlag = false;

  /// income
  List<String> incomeName = [];
  List<String> incomeAmount = [];
  List<String> incomeType = [];
  List<IconItem> incomeIcons = [];
  List<String> incomeIds = [];

  final auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  void showAllIncome() {
    showAllIncomeFlag = true;
    showAllExpenseFlag = false;
    notifyListeners();
  }

  void showAllExpense() {
    showAllExpenseFlag = true;
    showAllIncomeFlag = false;
    notifyListeners();
  }

  Future<void> addTransaction(BuildContext context) async {
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
                      id: '',
                      // Add this line
                      name: nameController.text,
                      amount: amountController.text,
                      type: 'expense',
                      icon: selectedIcon!,
                    );
                    var docRef = await userCollection
                        .doc(auth.currentUser!.uid)
                        .collection('transactions')
                        .add(expenseModel.toJson()..['type'] = 'expense');
                    expenseModel.id = docRef.id; // Update the id
                    expenseIds.add(docRef.id);
                  } else if (selectedTransactionType == 'income') {
                    IncomeModel incomeModel = IncomeModel(
                      id: '',
                      name: nameController.text,
                      amount: amountController.text,
                      type: 'income',
                      icon: selectedIcon!,
                    );
                    var docRef = await userCollection
                        .doc(auth.currentUser!.uid)
                        .collection('transactions')
                        .add(incomeModel.toJson()..['type'] = 'income');
                    incomeModel.id = docRef.id; // Update the id
                    incomeIds.add(docRef.id);
                  }
                }
                nameController.clear();
                amountController.clear();

                selectedIcon = null;
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
        .doc(auth.currentUser!.uid)
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
        expenseIds =
            expenses.map((expense) => expense.id).toList(); // Add this line
      } else if (type == 'income') {
        income = snapshot.docs.map((doc) {
          return IncomeModel.fromSnap(doc);
        }).toList();

        // Extracting relevant data
        incomeName = income.map((income) => income.name).toList();
        incomeAmount = income.map((income) => income.amount).toList();
        incomeType = income.map((income) => income.type).toList();
        incomeIcons = income.map((income) => income.icon).toList();
        incomeIds = income.map((income) => income.id).toList(); // Add this line
      }
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id, String type) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('users');
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await userCollection
          .doc(userId)
          .collection('transactions')
          .doc(id)
          .delete();

      removeTransactionById(id, type);
      print('deleting ');
      notifyListeners();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  void removeTransactionById(String id, String type) {
    List<String> namesList;
    List<String> amountsList;
    List<String> typesList;
    List<IconItem> iconsList;
    List<String> idsList;

    if (type == 'expense') {
      namesList = expensesName;
      amountsList = expensesAmount;
      typesList = expenseType;
      iconsList = expenseIcons;
      idsList = expenseIds;
    } else {
      namesList = incomeName;
      amountsList = incomeAmount;
      typesList = incomeType;
      iconsList = incomeIcons;
      idsList = incomeIds;
    }

    final index = idsList.indexOf(id);

    if (index != -1) {
      namesList.removeAt(index);
      amountsList.removeAt(index);
      typesList.removeAt(index);
      iconsList.removeAt(index);
      idsList.removeAt(index);
    }
    notifyListeners();
    print('Removing ');
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
// Future<void> addTransaction(
//   BuildContext context,
// ) async {
//   try {
//     final formKey = GlobalKey<FormState>();
//
//     return await showDialog(
//       context: context,
//       builder: (context) {
//         return AddTransactionTile(
//           amountController: amountController,
//           nameController: nameController,
//           formKey: formKey,
//           onTap: () async {
//             try {
//               if (formKey.currentState!.validate()) {
//                 if (selectedTransactionType == 'expense') {
//                   ExpenseModel expenseModel = ExpenseModel(
//                     name: nameController.text,
//                     amount: amountController.text,
//                     type: 'expense',
//                     icon: selectedIcon!,
//                   );
//                   await userCollection
//                       .doc(_auth.currentUser!.uid)
//                       .collection('transactions')
//                       .add(expenseModel.toJson()..['type'] = 'expense');
//                 } else if (selectedTransactionType == 'income') {
//                   IncomeModel incomeModel = IncomeModel(
//                     name: nameController.text,
//                     amount: amountController.text,
//                     type: 'income',
//                     icon: selectedIcon!,
//                   );
//                   await userCollection
//                       .doc(_auth.currentUser!.uid)
//                       .collection('transactions')
//                       .add(incomeModel.toJson()..['type'] = 'income');
//                 }
//               }
//               nameController.clear();
//               amountController.clear();
//               Navigator.pop(context);
//
//               showSnackBar(context, 'Successfully added', Colors.green);
//             } catch (e) {
//               log('Adding Transaction Error  $e');
//             }
//           },
//           transactionIcons: transactionIcons,
//         );
//       },
//     );
//   } catch (e) {
//     dialogBox(
//       context,
//       e.toString(),
//     );
//   }
//   notifyListeners();
// }

// Future<void> transactionsStream(String type) async {
//   await for (var snapshot in userCollection
//       .doc(_auth.currentUser!.uid)
//       .collection('transactions')
//       .where('type', isEqualTo: type)
//       .snapshots()) {
//     if (type == 'expense') {
//       expenses = snapshot.docs.map((doc) {
//         return ExpenseModel.fromSnap(doc);
//       }).toList();
//
//       // Extracting relevant data
//       expensesAmount = expenses.map((expense) => expense.amount).toList();
//       expensesName = expenses.map((expense) => expense.name).toList();
//       expenseType = expenses.map((expense) => expense.type).toList();
//       expenseIcons = expenses.map((expense) => expense.icon).toList();
//     } else if (type == 'income') {
//       income = snapshot.docs.map((doc) {
//         return IncomeModel.fromSnap(doc);
//       }).toList();
//
//       // Extracting relevant data
//       incomeName = income.map((income) => income.name).toList();
//       incomeAmount = income.map((income) => income.amount).toList();
//       incomeType = income.map((income) => income.type).toList();
//       incomeIcons = income.map((income) => income.icon).toList();
//     }
//     notifyListeners();
//   }
// }

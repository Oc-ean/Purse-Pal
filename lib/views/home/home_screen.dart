import 'package:budget_app/models/icon_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view_model/auth_model.dart';
import 'package:budget_app/view_model/logic_model.dart';
import 'package:budget_app/views/home/profile_screen.dart';
import 'package:budget_app/views/home/widgets/transaction_tile.dart';
import 'package:budget_app/views/home/widgets/transaction_type_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    AuthModelProvider userModel =
        Provider.of<AuthModelProvider>(context, listen: false);
    await userModel.updateUserDetails();

    // await logicModelProvider.transactionsStream('expense');
    // await logicModelProvider.transactionsStream('income');
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? userModel = Provider.of<AuthModelProvider>(
      context,
    ).userModel;

    final logicModelProvider = Provider.of<LogicModelProvider>(
      context,
      listen: false,
    );
    final width = MediaQuery.of(context).size.width;

    int totalExpenses = 0;
    int totalIncome = 0;

    void calculate() {
      for (int i = 0; i < logicModelProvider.expensesAmount.length; i++) {
        totalExpenses =
            totalExpenses + int.parse(logicModelProvider.expensesAmount[i]);
      }
      for (int i = 0; i < logicModelProvider.incomeAmount.length; i++) {
        totalIncome =
            totalIncome + int.parse(logicModelProvider.incomeAmount[i]);
      }
    }

    calculate();

    int totalBalance = totalIncome - totalExpenses;
    List<String> allTransactionNames = [];
    List<String> allTransactionAmounts = [];
    List<String> allType = [];
    List<IconItem> allIcons = [];

    allTransactionNames.addAll(logicModelProvider.expensesName);
    allTransactionNames.addAll(logicModelProvider.incomeName);
    allTransactionAmounts.addAll(logicModelProvider.expensesAmount);
    allTransactionAmounts.addAll(logicModelProvider.incomeAmount);
    allType.addAll(logicModelProvider.expenseType);
    allType.addAll(logicModelProvider.incomeType);
    allIcons.addAll(logicModelProvider.expenseIcons);
    allIcons.addAll(logicModelProvider.incomeIcons);

    logicModelProvider.transactionsStream('expense');
    logicModelProvider.transactionsStream('income');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: buildAppBar(context, userModel, logicModelProvider),
      body: SafeArea(
        child: userModel == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : StreamBuilder(
                stream: logicModelProvider.userCollection
                    .doc(logicModelProvider.auth.currentUser!.uid)
                    .collection('transactions')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    int totalExpenses = 0;
                    int totalIncome = 0;

                    for (var doc in snapshot.data!.docs) {
                      var data = doc.data() as Map<String, dynamic>;
                      if (data['type'] == 'expense') {
                        totalExpenses += int.parse(data['amount']);
                      } else if (data['type'] == 'income') {
                        totalIncome += int.parse(data['amount']);
                      }
                    }

                    int totalBalance = totalIncome - totalExpenses;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: Container(
                                width: width / 1.1,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'B A L A N C E',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        // letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '\$ $totalBalance',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TransactionType(
                                            width: width,
                                            typeText: 'INCOME',
                                            sign: '+',
                                            number: '$totalIncome',
                                            iconColor: Colors.green,
                                            iconCon: Colors.green.shade50,
                                            iconData:
                                                Icons.arrow_upward_outlined),
                                        TransactionType(
                                            width: width,
                                            sign: '-',
                                            typeText: 'EXPENSE',
                                            number: '$totalExpenses',
                                            iconColor: Colors.red,
                                            iconCon: Colors.red.shade50,
                                            iconData:
                                                Icons.arrow_downward_outlined),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Consumer2<AuthModelProvider, LogicModelProvider>(
                              builder: (BuildContext context,
                                  AuthModelProvider value,
                                  LogicModelProvider logic,
                                  Widget? child) {
                                String title = logic.showAllExpenseFlag
                                    ? 'Expense Transactions'
                                    : logic.showAllIncomeFlag
                                        ? 'Income Transactions'
                                        : 'Recent Transactions';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _buildList(
                                      title: '',
                                      names: allTransactionNames,
                                      amounts: allTransactionAmounts,
                                      type: allType,
                                      iconItem: allIcons,
                                      logicModelProvider: logic,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logicModelProvider.addTransaction(
            context,
          );
        },
        backgroundColor: const Color(0xFF222222),
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserModel? userModel,
      LogicModelProvider logicModelProvider) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.transparent),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Row(
        children: [
          Text(
            'PURSE',
            style: TextStyle(
              color: Colors.indigo.shade200,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            'PAL',
            style: TextStyle(
              color: Color(0xFF18101e),
              fontSize: 15,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'View All Income') {
                logicModelProvider.showAllIncome();
              } else if (result == 'View All Expense') {
                logicModelProvider.showAllExpense();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'View All Income',
                child: Text('View All Income'),
              ),
              const PopupMenuItem<String>(
                value: 'View All Expense',
                child: Text('View All Expense'),
              ),
            ],
            icon: const Icon(
              CupertinoIcons.chevron_down,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
            icon: const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0xFF371152),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildList({
    String? title,
    required List<String> names,
    required List<String> amounts,
    required List<String> type,
    required List<IconItem> iconItem,
    required LogicModelProvider logicModelProvider,
    // required List<String> ids,
  }) {
    List<String> filteredNames = [];
    List<String> filteredAmounts = [];
    List<String> filteredTypes = [];
    List<IconItem> filteredIcons = [];
    List<String> filteredId = [];

    // Check the flags to determine which transactions to display
    if (logicModelProvider.showAllIncomeFlag) {
      filteredNames = logicModelProvider.incomeName;
      filteredAmounts = logicModelProvider.incomeAmount;
      filteredTypes = logicModelProvider.incomeType;
      filteredIcons = logicModelProvider.incomeIcons;
      filteredId = logicModelProvider.incomeIds;
    } else if (logicModelProvider.showAllExpenseFlag) {
      filteredNames = logicModelProvider.expensesName;
      filteredAmounts = logicModelProvider.expensesAmount;
      filteredTypes = logicModelProvider.expenseType;
      filteredIcons = logicModelProvider.expenseIcons;
      filteredId = logicModelProvider.expenseIds;
    } else {
      // Show all transactions
      filteredNames.addAll(logicModelProvider.expensesName);
      filteredNames.addAll(logicModelProvider.incomeName);
      filteredAmounts.addAll(logicModelProvider.expensesAmount);
      filteredAmounts.addAll(logicModelProvider.incomeAmount);
      filteredTypes.addAll(logicModelProvider.expenseType);
      filteredTypes.addAll(logicModelProvider.incomeType);
      filteredIcons.addAll(logicModelProvider.expenseIcons);
      filteredIcons.addAll(logicModelProvider.incomeIcons);
      filteredId.addAll(logicModelProvider.expenseIds);
      filteredId.addAll(logicModelProvider.incomeIds);
    }
    bool showEmptyMessage = (!logicModelProvider.showAllIncomeFlag &&
            !logicModelProvider.showAllExpenseFlag &&
            filteredNames.isEmpty) ||
        (logicModelProvider.showAllIncomeFlag && filteredNames.isEmpty) ||
        (logicModelProvider.showAllExpenseFlag && filteredNames.isEmpty);

    if (showEmptyMessage) {
      return const SizedBox(
        height: 350,
        child: Center(
          child: Text(
            'No transactions available',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredNames.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final allType = filteredTypes[index];
        final allIcons = filteredIcons[index];
        final allIds = filteredId;

        return TransactionTile(
          text: filteredNames[index],
          amount: filteredAmounts[index],
          textColor: allType == 'expense' ? Colors.red : Colors.green,
          sign: allType == 'expense' ? '-' : '+',
          icon: allIcons.icon,
          iconText: allIcons.text,
          deleteFunction: (context) {
            logicModelProvider.deleteTransaction(allIds[index], allType[index]);
            print('SOmething');
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }
}

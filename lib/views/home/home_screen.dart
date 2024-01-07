import 'package:budget_app/models/icon_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view_model/auth_model.dart';
import 'package:budget_app/view_model/logic_model.dart';
import 'package:budget_app/views/home/profile_screen.dart';
import 'package:budget_app/views/home/widgets/transaction_tile.dart';
import 'package:budget_app/views/home/widgets/transaction_type_tile.dart';
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

    final logicModelProvider =
        Provider.of<LogicModelProvider>(context, listen: false);
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
      appBar: buildAppBar(context, userModel),
      body: SafeArea(
        child: userModel == null
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Container(
                          width: width / 1.1,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'B A L A N C E',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  // letterSpacing: 1.5,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '\$ $totalBalance',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(
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
                                      iconData: Icons.arrow_upward_outlined),
                                  TransactionType(
                                      width: width,
                                      sign: '-',
                                      typeText: 'EXPENSE',
                                      number: '$totalExpenses',
                                      iconColor: Colors.red,
                                      iconCon: Colors.red.shade50,
                                      iconData: Icons.arrow_downward_outlined),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Recent Transaction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      _buildList(
                        title: '',
                        names: allTransactionNames,
                        amounts: allTransactionAmounts,
                        type: allType,
                        iconItem: allIcons,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logicModelProvider.addTransaction(
            context,
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF222222),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserModel? userModel) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.transparent),
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
          Text(
            'PAL',
            style: TextStyle(
              color: Color(0xFF18101e),
              fontSize: 15,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
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
                  builder: (_) => ProfileScreen(),
                ),
              );
            },
            icon: CircleAvatar(
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
  }) {
    return Column(
      children: [
        Text(
          title!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: names.length,
          itemBuilder: (context, index) {
            final allType = type[index];
            final allIcons = iconItem[index];
            print('All Names ${names[index]}');
            print('All Type ${allType}');
            print('All icon${allIcons.icon}');
            print('Icon Text ${allIcons.text}');
            return TransactionTile(
              text: names[index],
              amount: amounts[index],
              textColor: allType == 'expense' ? Colors.red : Colors.green,
              sign: allType == 'expense' ? '-' : '+',
              icon: allIcons.icon,
              iconText: allIcons.text,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        ),
      ],
    );
  }
}

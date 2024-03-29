import 'package:budget_app/constants/reusables.dart';
import 'package:budget_app/view_model/logic_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/icon_model.dart';

class AddTransactionTile extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController amountController;
  final VoidCallback onTap;
  final GlobalKey formKey;
  final List<IconItem>? transactionIcons;
  const AddTransactionTile({
    super.key,
    required this.onTap,
    required this.nameController,
    required this.amountController,
    required this.formKey,
    this.transactionIcons,
  });

  @override
  State<AddTransactionTile> createState() => _AddTransactionTileState();
}

class _AddTransactionTileState extends State<AddTransactionTile> {
  @override
  Widget build(BuildContext context) {
    var selectType = Provider.of<LogicModelProvider>(context);
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<IconItem>(
                value: selectType.selectedIcon,
                onChanged: (value) {
                  setState(() {
                    selectType.selectedIcon = (value)!;
                  });
                },
                items: widget.transactionIcons!
                    .map((iconItem) => DropdownMenuItem(
                          value: iconItem,
                          child: Row(
                            children: [
                              Icon(iconItem.icon),
                              const SizedBox(width: 8),
                              Text(iconItem.text),
                            ],
                          ),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  label: Text(
                    'Category',
                    style: TextStyle(color: Colors.black, height: 1.5),
                  ),
                  contentPadding: EdgeInsets.only(
                    top: 5,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 200,
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField(
                value: selectType.selectedTransactionType,
                onChanged: (value) {
                  setState(() {
                    selectType.selectedTransactionType = value.toString();
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'expense',
                    child: Text(
                      'Expense',
                      style: TextStyle(letterSpacing: 0.8),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'income',
                    child: Text(
                      'Income',
                      style: TextStyle(letterSpacing: 0.8),
                    ),
                  ),
                ],
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            reusableTextField(
                controller: widget.nameController,
                width: 200,
                hintText: 'Name',
                isObscure: false,
                textColor: Colors.black,
                borderColor: Colors.black,
                textInputType: TextInputType.name,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            reusableTextField(
              controller: widget.amountController,
              hintText: 'Amount',
              width: 200,
              isObscure: false,
              textColor: Colors.black,
              borderColor: Colors.black,
              textInputType: TextInputType.number,
              validator: (text) {
                if (text.toString().isEmpty) {
                  return 'Required';
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                  splashColor: Colors.grey,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: widget.onTap,
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  splashColor: Colors.grey,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

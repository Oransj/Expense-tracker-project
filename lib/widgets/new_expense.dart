import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(1970, 1, 1);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text("Invalid input"),
                content:
                    const Text("Please make sure you have set all values."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Ok"),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid input"),
          content: const Text("Please make sure you have set all values."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  void _saveExpenseData() {
    final amount = double.tryParse(_amountController.text);
    final invalidAmount = amount == null || amount <= 0;
    if (_titleController.text.trim().isEmpty ||
        invalidAmount ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var titleComponent = TextField(
      controller: _titleController,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
    );

    var amountComponent = Expanded(
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefixText: '\$ ',
          label: Text('Amount'),
        ),
      ),
    );

    var dropDownButton = DropdownButton(
        value: _selectedCategory,
        items: Category.values
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name.toUpperCase()),
                ))
            .toList(),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _selectedCategory = value;
          });
        });

    var dateSelector = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null
                ? "No date selected"
                : formatter.format(_selectedDate!),
          ),
          IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
    );

    var cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "Cancel",
      ),
    );

    var confirmButton =
        ElevatedButton(onPressed: _saveExpenseData, child: const Text('Save'));

    final keyBoardSize = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSize + 16),
            child: Column(children: [
              if (width >= 600)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: titleComponent,
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    amountComponent,
                  ],
                )
              else
                titleComponent,
              if (width >= 600)
                Row(
                  children: [
                    dropDownButton,
                    const SizedBox(
                      width: 24,
                    ),
                    dateSelector,
                  ],
                )
              else
                Row(
                  children: [
                    amountComponent,
                    const SizedBox(
                      width: 16,
                    ),
                    dateSelector,
                  ],
                ),
              const SizedBox(
                height: 16,
              ),
              if (width >= 600)
                Row(
                  children: [
                    const Spacer(),
                    cancelButton,
                    confirmButton,
                  ],
                )
              else
                Row(
                  children: [
                    dropDownButton,
                    const Spacer(),
                    cancelButton,
                    confirmButton,
                  ],
                )
            ]),
          ),
        ),
      );
    });
  }
}

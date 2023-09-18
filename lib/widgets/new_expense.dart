import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is a stateful widget since it stores the user input.
/// Creates the overlay for adding a new expense and calls the callback when the user finishes.
class NewExpense extends StatefulWidget {
  //Constructor
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

/// This is the private State class that goes with NewExpense.
class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController(); //Controller for the title
  final _amountController = TextEditingController(); //Controller for the amount
  DateTime? _selectedDate; //The selected date
  Category _selectedCategory =
      Category.leisure; //The selected category, default is leisure

  @override
  void dispose() {
    //Disposes the controllers when the widget is removed
    _titleController.dispose();
    super.dispose();
  }

  /// Opens the date picker.
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

  /// Shows an error dialog.
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

  /// Saves the expense data and calls the callback.
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

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    var titleComponent = TextField(
      controller: _titleController, //Sets the controller
      maxLength: 50, //Limits the length of the input
      decoration: const InputDecoration(
        //Sets the decoration, in this case the label
        label: Text('Title'),
      ),
    );

    var amountComponent = Expanded(
      //Makes the component take up all the remaining space
      child: TextField(
        //Creates a text field
        controller: _amountController, //Sets the controller
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          //Sets the decoration, in this case the label
          prefixText: '\$ ', //Adds a prefix to the input
          label: Text('Amount'),
        ),
      ),
    );

    var dropDownButton = DropdownButton(
        //Creates a dropdown button
        value: _selectedCategory, //Sets the selected value
        items: Category.values //Creates the items
            .map((category) => DropdownMenuItem(
                  //Creates a dropdown menu item
                  value: category,
                  child: Text(category.name.toUpperCase()),
                ))
            .toList(), //Converts the iterable to a list
        onChanged: (value) {
          //Sets the onChanged callback
          if (value == null) {
            return; //Returns if the value is null
          }
          setState(() {
            _selectedCategory =
                value; //Sets the selected category and updates the widget
          });
        });

    var dateSelector = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null //Displays the selected date or a placeholder
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
        Navigator.pop(context); //Closes the overlay
      },
      child: const Text(
        "Cancel",
      ),
    );

    var confirmButton = ElevatedButton(
        onPressed: _saveExpenseData,
        child: const Text('Save')); //Creates the confirm button

    final keyBoardSize =
        MediaQuery.of(context).viewInsets.bottom; //Gets the keyboard size
    return LayoutBuilder(builder: (ctx, constraints) {
      //Creates a layout builder
      final width = constraints.maxWidth; //Gets the max width

      return SizedBox(
        height:
            double.infinity, //Makes the widget take up all the available space
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16,
                keyBoardSize + 16), //Adds padding and avoids the keyboard
            child: Column(children: [
              if (width >= 600) //Checks if the screen is wider than 600 pixels
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, //Aligns the text to the left
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
              if (width >= 600) //Checks if the screen is wider than 600 pixels
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

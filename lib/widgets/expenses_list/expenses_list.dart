import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

/// Displays the list of expenses.
/// Is Stateless since it does not change.
class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense; //Callback

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        //Creates a scrollable list
        shrinkWrap:
            true, //Makes the list only take up as much space as needed (Causes error if not there and in a column)
        itemCount: expenses.length,
        itemBuilder: (context, index) => Dismissible(
            //Makes the list items dismissible
            key: ValueKey(expenses[index]),
            background: Container(
              //The background when swiping
              color: Theme.of(context).colorScheme.error.withOpacity(
                  0.75), //Sets the color to the theme's error color
              margin: EdgeInsets.symmetric(
                  //Adds a margin
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal),
            ),
            onDismissed: (value) => onRemoveExpense(
                expenses[index]), //Calls the callback and removes the expense
            child: ExpenseItem(expenses[index])), //Creates the list item
      ),
    );
  }
}

import 'package:expense_tracker/widgets/charts/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/month_expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
/// It is stateful because it stores the changing list of expenses.
/// Creates the main page of the app.
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

/// This is the private State class that goes with Expenses.
class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    //Placeholder expenses
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 9.99,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  /// Opens the overlay for adding a new expense.
  /// Called when the user presses the add button.
  /// Adds the expense to the list of expenses.
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        //Opens the overlay
        useSafeArea:
            true, //Makes sure the overlay is not hidden by the keyboard
        isScrollControlled: true, //Makes the overlay scrollable
        context: context,
        builder: (ctx) => NewExpense(
            onAddExpense:
                _addExpense)); //:addExpense is run when the user finishes
  }

  /// Adds the expense to the list of expenses.
  void _addExpense(Expense expense) {
    //Makes Flutter rebuild the widget since the list of expenses has changed
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  /// Removes the expense from the list of expenses.
  void _removeExpense(Expense expense) {
    final index =
        _registeredExpenses.indexOf(expense); //Gets the index of the expense
    setState(() {
      _registeredExpenses.remove(expense); //Removes the expense from the list
    });
    ScaffoldMessenger.of(context)
        .clearSnackBars(); //Clears all snackbars in queue
    ScaffoldMessenger.of(context).showSnackBar(
      //Shows a snackbar
      SnackBar(
        duration:
            const Duration(seconds: 3), //Sets the duration of the snackbar
        content:
            const Text("Expense deleted"), //Sets the content of the snackbar
        action: SnackBarAction(
          //Sets what happens when the user presses the action button
          label: 'Undo', //Sets the label of the action button
          onPressed: () {
            setState(() {
              //Re-adds the expense to the list
              _registeredExpenses.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    //Shows a message if there are no expenses
    Widget mainContent = const Center(
      child: Text("Wow, such empty"),
    );

    //Shows the expenses if there are any
    if (_registeredExpenses.isNotEmpty) {
      mainContent = Column(
        //Creates a column with the monthly expenses comparison widget and the list of expenses
        children: [
          MonthlyExpenseWidget(expenses: _registeredExpenses),
          ExpensesList(
            expenses:
                _registeredExpenses, //Passes the list of expenses to the list of expenses widget
            onRemoveExpense:
                _removeExpense, //Passes the remove expense function to the list of expenses widget
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        //Creates the appbar, the top part of the screen
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
              //Creates the add button
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add)),
        ],
      ),
      body: width < 600 //Checks if the screen is smaller than 600 pixels wide
          ? Column(
              children: [
                //Creates a column with the monthly expenses comparison widget and the list of expenses
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Expanded(
              //Creates a row with the monthly expenses comparison widget and the list of expenses
              child: Row(children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                )
              ]),
            ),
    );
  }
}

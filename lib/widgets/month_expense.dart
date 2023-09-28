import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

/// Displays the total expenses of the current and last month.
/// Is Stateless since it does not change.
/// Is not visible if there are no expenses.
class MonthlyExpenseWidget extends StatelessWidget {
  const MonthlyExpenseWidget({super.key, required this.expenses});

  final List<Expense> expenses;

  /// Returns the total expenses of the given month.
  double getTotalExpensesOfMonth(int month) {
    var monthlyExpenses =
        expenses.where((element) => element.date.month == month).toList();
    double total = 0;
    for (var element in monthlyExpenses) {
      total += element.amount;
    }
    return total;
  }

  /// Builds the widget
  @override
  Widget build(BuildContext context) {
    var date = DateTime.now(); //The current date
    return Card(
      child: Padding(
        //Padding is used to add space around the widget
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SizedBox(
          child: Row(
            //Row is used to display the icon and the text next to each other
            children: [
              Expanded(
                child: Column(
                  //Column is used to display the text below each other
                  crossAxisAlignment:
                      CrossAxisAlignment.start, //Aligns the text to the left
                  children: [
                    Text("Total expenses: ",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge), //Sets the style to the theme's titleLarge
                    const SizedBox(height: 8),
                    Text(
                      "This month: ${getTotalExpensesOfMonth(date.month).toStringAsFixed(2)}\$",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium, //Sets the style to the theme's titleMedium
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Last month: ${getTotalExpensesOfMonth(DateTime(date.year, date.month - 1, date.day).month).toStringAsFixed(2)}\$",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium, //Sets the style to the theme's titleMedium
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.attach_money_rounded, //Sets the icon to the money icon
                size: 48,
                color: Theme.of(context)
                    .iconTheme
                    .color, //Sets the color to the theme's icon color
              ),
            ],
          ),
        ),
      ),
    );
  }
}

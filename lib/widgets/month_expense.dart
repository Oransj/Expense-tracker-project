import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class MonthlyExpenseWidget extends StatelessWidget {
  const MonthlyExpenseWidget({super.key, required this.expenses});

  final List<Expense> expenses;

  double getTotalExpensesOfMonth(int month) {
    var monthlyExpenses =
        expenses.where((element) => element.date.month == month).toList();
    double total = 0;
    for (var element in monthlyExpenses) {
      total += element.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SizedBox(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total expenses: ",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "This month: ${getTotalExpensesOfMonth(date.month).toStringAsFixed(2)}\$",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Last month: ${getTotalExpensesOfMonth(DateTime(date.year, date.month - 1, date.day).month).toStringAsFixed(2)}\$",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.attach_money_rounded,
                size: 48,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

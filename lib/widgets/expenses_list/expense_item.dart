import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

/// Displays a single expense.
class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      //Creates a card
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 16), //Adds padding
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, //Aligns the text to the left
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                    '\$${expense.amount.toStringAsFixed(2)}'), //Formats the amount to 2 decimal places
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

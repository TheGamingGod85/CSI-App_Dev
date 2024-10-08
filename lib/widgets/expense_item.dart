// widgets/expense_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../screens/add_expense_screen.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.title),
      subtitle: Text(DateFormat.yMMMd().format(expense.date)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('₹${expense.amount.toStringAsFixed(2)}'),
              Text(expense.category),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddExpenseScreen(expense: expense),
                  ),
                );
              } else if (value == 'Delete') {
                Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense.id!);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'Delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

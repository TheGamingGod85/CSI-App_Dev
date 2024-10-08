// screens/category_expense_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_item.dart';

class CategoryExpenseScreen extends StatelessWidget {
  final String category;

  const CategoryExpenseScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses
        .where((expense) => expense.category == category)
        .toList();

    // Sort the expenses for the selected category by date in descending order
    expenses.sort((a, b) => b.date.compareTo(a.date));

    // Calculate total expenses for this category
    final totalExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Expenses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total for $category: ₹${totalExpense.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ExpenseItem(expense: expenses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

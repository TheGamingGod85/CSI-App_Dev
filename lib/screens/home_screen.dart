// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;

    // Calculate the total expenses
    final totalExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);

    // Group expenses by category and calculate category totals
    final Map<String, double> categoryTotals = {};
    expenses.forEach((expense) {
      if (!categoryTotals.containsKey(expense.category)) {
        categoryTotals[expense.category] = 0.0;
      }
      categoryTotals[expense.category] = categoryTotals[expense.category]! + expense.amount;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          // Display total expense
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expense: ₹${totalExpense.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Category color bar
                Container(
                  height: 20,
                  width: double.infinity,
                  child: Row(
                    children: categoryTotals.entries.map((entry) {
                      final category = entry.key;
                      final categoryTotal = entry.value;
                      final share = categoryTotal / totalExpense;
                      return Expanded(
                        flex: (share * 100).toInt(),
                        child: Container(
                          color: _getCategoryColor(category),
                          height: 20,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Display list of expenses
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        backgroundColor: Colors.blue, // Blue-colored FAB
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Helper function to get a color for each category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.green;
      case 'Transport':
        return Colors.blue;
      case 'Entertainment':
        return Colors.orange;
      case 'Others':
        return Colors.purple;
      default:
        return Colors.grey; // For custom categories or uncategorized expenses
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import '../widgets/expense_item.dart';
import 'category_expense_screen.dart';
import 'dart:math';

// Helper class to manage category colors
class CategoryColorManager {
  final Map<String, Color> _categoryColors = {};

  Color getCategoryColor(String category) {
    if (_categoryColors.containsKey(category)) {
      return _categoryColors[category]!;
    } else {
      // Predefined categories
      switch (category) {
        case 'Food':
          return _assignColor(category, Colors.green);
        case 'Transport':
          return _assignColor(category, Colors.blue);
        case 'Entertainment':
          return _assignColor(category, Colors.orange);
        case 'Others':
          return _assignColor(category, Colors.purple);
        default:
          // For custom categories, assign a random color
          return _assignRandomColor(category);
      }
    }
  }

  Color _assignColor(String category, Color color) {
    _categoryColors[category] = color;
    return color;
  }

  Color _assignRandomColor(String category) {
    Color randomColor = _generateRandomColor();
    _categoryColors[category] = randomColor;
    return randomColor;
  }

  Color _generateRandomColor() {
    final random = Random();
    Color randomColor;
    do {
      randomColor = Color.fromRGBO(
        random.nextInt(256), // Random Red
        random.nextInt(256), // Random Green
        random.nextInt(256), // Random Blue
        1.0,                 // Full opacity
      );
    } while (_categoryColors.containsValue(randomColor));
    return randomColor;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final CategoryColorManager _categoryColorManager = CategoryColorManager();

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    var expenses = expenseProvider.expenses;

    // Sort expenses by date in descending order
    expenses.sort((a, b) => b.date.compareTo(a.date));

    // Apply search filter
    expenses = expenses.where((expense) {
      final titleMatches = expense.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final priceMatches = expense.amount.toString().contains(_searchQuery);
      return titleMatches || priceMatches;
    }).toList();

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
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Display total expense
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expense: ₹${totalExpense.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Category color bar
                Container(
                  height: 20,
                  width: double.infinity,
                  child: Row(
                    children: categoryTotals.entries.map((entry) {
                      final category = entry.key;
                      final categoryTotal = entry.value;
                      final share = totalExpense == 0 ? 0.0 : categoryTotal / totalExpense;

                      return Expanded(
                        flex: (share * 100).toInt(),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CategoryExpenseScreen(category: category),
                              ),
                            );
                          },
                          child: Container(
                            color: _categoryColorManager.getCategoryColor(category),
                            height: 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name or price',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          // Display list of expenses
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ExpenseItem(expense: expenses[index]);
              },
            ),
          ),
          // Transparent bar with the FAB
          Container(
            color: Colors.transparent,
            height: 80,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                  );
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

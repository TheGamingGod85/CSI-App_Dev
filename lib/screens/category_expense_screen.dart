// screens/category_expense_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_item.dart';

class CategoryExpenseScreen extends StatefulWidget {
  final String category;

  const CategoryExpenseScreen({required this.category});

  @override
  _CategoryExpenseScreenState createState() => _CategoryExpenseScreenState();
}

class _CategoryExpenseScreenState extends State<CategoryExpenseScreen> {
  String _searchQuery = ''; // To track the search query

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    var categoryExpenses = expenseProvider.expenses
        .where((expense) => expense.category == widget.category)
        .toList();

    // Sort expenses by date in descending order
    categoryExpenses.sort((a, b) => b.date.compareTo(a.date));

    // Apply search filter
    categoryExpenses = categoryExpenses.where((expense) {
      final titleMatches = expense.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final priceMatches = expense.amount.toString().contains(_searchQuery);
      return titleMatches || priceMatches;
    }).toList();

    // Calculate the total expenses for the category
    final totalCategoryExpense = categoryExpenses.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Expenses'),
      ),
      body: Column(
        children: [
          // Display total category expense
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total ${widget.category} Expense: ₹${totalCategoryExpense.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Search bar to filter expenses within this category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update search query
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name or price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              style: TextStyle(fontSize: 14), // Make the text smaller
            ),
          ),
          // Display list of category expenses (sorted and filtered by search query)
          Expanded(
            child: ListView.builder(
              itemCount: categoryExpenses.length,
              itemBuilder: (context, index) {
                return ExpenseItem(expense: categoryExpenses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// providers/expense_provider.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  ExpenseProvider() {
    _loadExpenses(); // Load expenses when the provider is initialized
  }

  List<Expense> get expenses => _expenses;

  Future<void> _loadExpenses() async {
    final database = await _openDatabase();
    final List<Map<String, dynamic>> expenseMaps = await database.query('expenses');
    
    _expenses = List.generate(expenseMaps.length, (index) {
      return Expense(
        id: expenseMaps[index]['id'],
        title: expenseMaps[index]['title'],
        amount: expenseMaps[index]['amount'],
        category: expenseMaps[index]['category'],
        date: DateTime.parse(expenseMaps[index]['date']),
      );
    });

    notifyListeners(); // Notify listeners after loading data
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'expenses_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY, title TEXT, amount REAL, category TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  // Existing methods for adding, updating, and deleting expenses
  Future<void> addExpense(Expense expense) async {
    final database = await _openDatabase();
    await database.insert('expenses', {
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date.toIso8601String(),
    });
    await _loadExpenses(); // Reload expenses after adding
  }

  // Similarly, update your updateExpense and deleteExpense methods
}

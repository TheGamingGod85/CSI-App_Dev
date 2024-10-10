// providers/expense_provider.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  // Public method to load expenses
  Future<void> loadExpenses() async {
    await _loadExpenses();
  }

  // Load expenses from the database
  Future<void> _loadExpenses() async {
    final database = await _openDatabase();
    final List<Map<String, dynamic>> expenseMaps = await database.query('expenses');
    
    _expenses = List.generate(expenseMaps.length, (index) {
      return Expense.fromMap(expenseMaps[index]);
    });

    notifyListeners();
  }

  // Open the SQLite database
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

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    final database = await _openDatabase();
    await database.insert('expenses', expense.toMap());
    await _loadExpenses(); 
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    final database = await _openDatabase();
    await database.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    await _loadExpenses();
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    final database = await _openDatabase();
    await database.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadExpenses();
  }
}

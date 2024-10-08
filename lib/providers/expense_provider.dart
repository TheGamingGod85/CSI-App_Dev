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

  // Load expenses from the database
  Future<void> _loadExpenses() async {
    final database = await _openDatabase();
    final List<Map<String, dynamic>> expenseMaps = await database.query('expenses');
    
    _expenses = List.generate(expenseMaps.length, (index) {
      return Expense.fromMap(expenseMaps[index]); // Use fromMap method to create Expense instances
    });

    notifyListeners(); // Notify listeners after loading data
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
    await database.insert('expenses', expense.toMap()); // Use toMap method for inserting
    await _loadExpenses(); // Reload expenses after adding
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    final database = await _openDatabase();
    await database.update(
      'expenses',
      expense.toMap(), // Use toMap method for updating
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    await _loadExpenses(); // Reload expenses after updating
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    final database = await _openDatabase();
    await database.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadExpenses(); // Reload expenses after deleting
  }
}

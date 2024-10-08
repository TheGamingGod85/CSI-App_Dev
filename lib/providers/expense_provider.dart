// providers/expense_provider.dart
import 'package:flutter/material.dart';
import '../db/expense_db.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    _expenses = await ExpenseDB().getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await ExpenseDB().addExpense(expense);
    await fetchExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await ExpenseDB().updateExpense(expense);
    await fetchExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await ExpenseDB().deleteExpense(id);
    await fetchExpenses();
  }
}

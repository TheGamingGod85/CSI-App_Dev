// screens/add_expense_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;
  String _category = 'Food';
  DateTime _selectedDate = DateTime.now();

  // Predefined categories
  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Others'];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _title = widget.expense!.title;
      _amount = widget.expense!.amount;
      _category = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to add a custom category
  Future<void> _addCustomCategory(BuildContext context) async {
    TextEditingController _customCategoryController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Category'),
          content: TextField(
            controller: _customCategoryController,
            decoration: const InputDecoration(hintText: "Enter custom category"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_customCategoryController.text.isNotEmpty) {
                  setState(() {
                    _category = _customCategoryController.text;
                    _categories.add(_customCategoryController.text);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    _title = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: TextFormField(
                initialValue: _amount != 0 ? _amount.toString() : '',
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList()
                  ..add(const DropdownMenuItem(
                    value: 'Add Custom',
                    child: Text('Add Custom'),
                  )),
                onChanged: (value) {
                  if (value == 'Add Custom') {
                    _addCustomCategory(context); // Show dialog to add custom category
                  } else {
                    setState(() {
                      _category = value!;
                    });
                  }
                },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent), 
                    borderRadius: BorderRadius.circular(10.0), 
                    color: const Color(0x1A3764).withOpacity(0.5), 
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Date: ${DateFormat.yMMMd().format(_selectedDate)}', 
                          style: const TextStyle(fontSize: 16, color: Colors.white), 
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.white), 
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newExpense = Expense(
                      id: widget.expense?.id,
                      title: _title,
                      amount: _amount,
                      date: _selectedDate,
                      category: _category,
                    );

                    if (widget.expense == null) {
                      Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);
                    } else {
                      Provider.of<ExpenseProvider>(context, listen: false).updateExpense(newExpense);
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.expense == null ? 'Add Expense' : 'Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

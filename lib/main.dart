// main.dart
import 'package:flutter/material.dart';
import 'package:myapp/theme/theme.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FuturFi',
        theme: AppTheme.themeData,
        home: SplashScreen(),
      ),
    );
  }
}

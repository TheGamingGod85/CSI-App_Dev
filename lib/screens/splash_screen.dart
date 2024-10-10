// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../providers/expense_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _numberAnimation;
  late Animation<Color?> _colorAnimation;
  int _displayedNumber = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Number lerp animation (for animated number transition)
    _numberAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _displayedNumber = _numberAnimation.value.toInt();
        });
      });

    // Background color gradient animation
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animations
    _controller.forward();

    // Add listener to navigate to home screen after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loadDataAndNavigate(); // Navigate to the home screen
      }
    });
  }

  Future<void> _loadDataAndNavigate() async {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    await expenseProvider.loadExpenses();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _colorAnimation.value ?? Colors.blue,
                  Colors.pink.shade400,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₹$_displayedNumber',
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Animated text effect for app name and tagline
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'FuturFi',
                        textStyle: const TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                      TyperAnimatedText(
                        'Track, Save, Thrive.',
                        textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                        speed: const Duration(milliseconds: 150),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

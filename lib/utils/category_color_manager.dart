import 'dart:math';
import 'package:flutter/material.dart';

class CategoryColorManager {
  static final Map<String, Color> _categoryColors = {};
  static final Random _random = Random();

  
  Color _generateBrightFuturisticColor() {
    int minValue = 128;
    int maxValue = 255;

    
    int red = _random.nextInt(maxValue - minValue) + minValue;
    int green = _random.nextInt(maxValue - minValue) + minValue;
    int blue = _random.nextInt(maxValue - minValue) + minValue;

    return Color.fromARGB(
      255,
      red,
      green,
      blue,
    );
  }

  // Assigns or retrieves the color for a category
  Color getCategoryColor(String category) {
    if (!_categoryColors.containsKey(category)) {
      // Ensure no duplicate colors
      Color newColor;
      do {
        newColor = _generateBrightFuturisticColor();
      } while (_categoryColors.containsValue(newColor));

      _categoryColors[category] = newColor; // Store the color
    }
    return _categoryColors[category]!;
  }
}

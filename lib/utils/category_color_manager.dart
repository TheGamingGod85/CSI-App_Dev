import 'dart:math';
import 'package:flutter/material.dart';

class CategoryColorManager {
  static final Map<String, Color> _categoryColors = {};
  static final Random _random = Random();

  // Generates a random bright futuristic color
  Color _generateBrightFuturisticColor() {
    int minValue = 128;  // Ensures the color is not too dark
    int maxValue = 255;  // Maximum brightness

    // We bias the color generation to produce bright, neon-like colors
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

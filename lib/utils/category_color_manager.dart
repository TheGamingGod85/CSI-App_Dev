import 'dart:math';
import 'package:flutter/material.dart';

class CategoryColorManager {
  static final Map<String, Color> _categoryColors = {};
    static final Random _random = Random();

      // Generates a random color
        Color _generateRandomColor() {
            return Color.fromARGB(
                  255,
                        _random.nextInt(256),
                              _random.nextInt(256),
                                    _random.nextInt(256),
                                        );
                                          }

                                            // Assigns or retrieves the color for a category
                                              Color getCategoryColor(String category) {
                                                  if (!_categoryColors.containsKey(category)) {
                                                        // Ensure no duplicate colors
                                                              Color newColor;
                                                                    do {
                                                                            newColor = _generateRandomColor();
                                                                                  } while (_categoryColors.containsValue(newColor));

                                                                                        _categoryColors[category] = newColor; // Store the color
                                                                                            }
                                                                                                return _categoryColors[category]!;
                                                                                                  }
                                                                                                  }
                                                                                                  
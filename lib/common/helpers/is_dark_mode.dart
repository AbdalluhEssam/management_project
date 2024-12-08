

import 'package:flutter/material.dart';

extension DarkModeHelper on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/form_screen.dart';
import '../screens/detail_screen.dart';

/// Centralized route definitions for named navigation throughout the application.
class AppRoutes {
  static const String home = '/';
  static const String form = '/form';
  static const String detail = '/detail';

  /// Named routes table registered in MaterialApp
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        form: (context) => const FormScreen(),
        detail: (context) => const DetailScreen(),
      };
}

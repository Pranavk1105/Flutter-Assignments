import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const Assignment7App());
}

/// Root widget of Assignment 7 setting up Material 3 theming and Named Route table.
class Assignment7App extends StatelessWidget {
  const Assignment7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 7 - Named Routes & Validation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      // Declarative Named Routing
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}

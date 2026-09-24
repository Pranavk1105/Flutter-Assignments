import 'package:flutter/material.dart';
import 'package:assignment_8/screens/post_list_screen.dart';
import 'package:assignment_8/services/post_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Assignment8App());
}

/// Root widget of Assignment 8 configuring Material 3 theming and the main screen.
class Assignment8App extends StatelessWidget {
  final PostRepository? repository;

  const Assignment8App({
    super.key,
    this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 8 - REST API & SharedPreferences',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1.5,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0.5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: PostListScreen(
        repository: repository ?? PostRepository(),
      ),
    );
  }
}

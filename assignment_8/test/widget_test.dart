import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment_8/main.dart';
import 'package:assignment_8/services/api_service.dart';
import 'package:assignment_8/services/cache_service.dart';
import 'package:assignment_8/services/post_repository.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  final sampleApiJson = jsonEncode([
    {
      'id': 1,
      'userId': 1,
      'title': 'first rest api post',
      'body': 'This is the first test body retrieved from JSONPlaceholder.',
    },
    {
      'id': 2,
      'userId': 1,
      'title': 'second cached article',
      'body': 'Demonstrating FutureBuilder and SharedPreferences.',
    },
    {
      'id': 3,
      'userId': 2,
      'title': 'third unique entry',
      'body': 'Another post testing search and detail navigation.',
    },
  ]);

  PostRepository createTestRepo({
    int statusCode = 200,
    String? body,
    bool simulateNetworkFailure = false,
  }) {
    final mockClient = MockClient((request) async {
      if (simulateNetworkFailure) {
        throw Exception('Network connection refused');
      }
      return http.Response(body ?? sampleApiJson, statusCode);
    });

    final apiService = ApiService(client: mockClient);
    final cacheService = CacheService();
    return PostRepository(apiService: apiService, cacheService: cacheService);
  }

  testWidgets('FutureBuilder renders loading state and transitions to live data',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repo = createTestRepo();
    await tester.pumpWidget(Assignment8App(repository: repo));

    // Initially loading skeleton should be visible
    expect(find.byType(CustomScrollView), findsNothing);

    // Settle async operations
    await tester.pumpAndSettle();

    // Verify UI displays live REST API content
    expect(find.text('Assignment 8'), findsOneWidget);
    expect(find.text('Live REST API'), findsOneWidget);
    expect(find.text('3 Posts'), findsOneWidget);
    expect(find.text('First rest api post'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
  });

  testWidgets('Tapping a post card navigates to PostDetailScreen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repo = createTestRepo();
    await tester.pumpWidget(Assignment8App(repository: repo));
    await tester.pumpAndSettle();

    // Tap first post card
    await tester.tap(find.byKey(const Key('post_card_1')));
    await tester.pumpAndSettle();

    // Verify detail screen components
    expect(find.text('Post #001'), findsOneWidget);
    expect(find.text('Author User ID: 1'), findsOneWidget);
    expect(find.text('First rest api post'), findsOneWidget);
    expect(find.text('This is the first test body retrieved from JSONPlaceholder.'),
        findsOneWidget);
    expect(find.text('JSONPlaceholder REST API'), findsOneWidget);

    // Pop back to list
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Assignment 8'), findsOneWidget);
  });

  testWidgets('Search query dynamically filters posts in real-time',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repo = createTestRepo();
    await tester.pumpWidget(Assignment8App(repository: repo));
    await tester.pumpAndSettle();

    // Verify all 3 posts are initially displayed
    expect(find.text('First rest api post'), findsOneWidget);
    expect(find.text('Second cached article'), findsOneWidget);
    expect(find.text('Third unique entry'), findsOneWidget);

    // Enter search text
    await tester.enterText(
        find.byKey(const Key('post_search_field')), 'cached');
    await tester.pumpAndSettle();

    // Only matching post should remain visible
    expect(find.text('Second cached article'), findsOneWidget);
    expect(find.text('First rest api post'), findsNothing);
    expect(find.text('Third unique entry'), findsNothing);

    // Clear search using clear icon
    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pumpAndSettle();

    // All posts restored
    expect(find.text('First rest api post'), findsOneWidget);
    expect(find.text('Second cached article'), findsOneWidget);
    expect(find.text('Third unique entry'), findsOneWidget);
  });

  testWidgets('Simulating offline mode falls back to SharedPreferences cache',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final repo = createTestRepo();
    await tester.pumpWidget(Assignment8App(repository: repo));
    await tester.pumpAndSettle();

    // First fetch should have saved to SharedPreferences cache
    expect(find.text('Live REST API'), findsOneWidget);

    // Tap the offline simulation chip
    await tester.tap(find.byKey(const Key('toggle_offline_chip')));
    await tester.pumpAndSettle();

    // Verify cache badge is now active
    expect(find.text('SharedPreferences Cache'), findsOneWidget);
    expect(find.textContaining('Offline mode active'), findsOneWidget);
  });

  testWidgets('ErrorDisplay renders when network fails and no cache exists',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final failureRepo = createTestRepo(simulateNetworkFailure: true);
    await tester.pumpWidget(Assignment8App(repository: failureRepo));
    await tester.pumpAndSettle();

    // Verify error state
    expect(find.text('Data Fetch Failed'), findsOneWidget);
    expect(find.byKey(const Key('retry_button')), findsOneWidget);
  });
}

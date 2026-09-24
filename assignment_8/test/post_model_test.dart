import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_8/models/post.dart';

void main() {
  group('Post Model Tests', () {
    test('fromJson correctly parses standard JSON data', () {
      final json = {
        'id': 1,
        'userId': 42,
        'title': 'flutter networking guide',
        'body': 'Learn how to fetch data from REST APIs using FutureBuilder.',
      };

      final post = Post.fromJson(json);

      expect(post.id, 1);
      expect(post.userId, 42);
      expect(post.title, 'flutter networking guide');
      expect(post.body,
          'Learn how to fetch data from REST APIs using FutureBuilder.');
    });

    test('fromJson gracefully falls back when fields are null or mismatched', () {
      final json = <String, dynamic>{
        'id': null,
        'userId': null,
        'title': null,
        'body': null,
      };

      final post = Post.fromJson(json);

      expect(post.id, 0);
      expect(post.userId, 0);
      expect(post.title, '');
      expect(post.body, '');
    });

    test('toJson produces expected Map representation', () {
      const post = Post(
        id: 10,
        userId: 3,
        title: 'offline caching',
        body: 'SharedPreferences persists key value pairs.',
      );

      final json = post.toJson();

      expect(json['id'], 10);
      expect(json['userId'], 3);
      expect(json['title'], 'offline caching');
      expect(json['body'], 'SharedPreferences persists key value pairs.');
    });

    test('capitalizedTitle capitalizes first character', () {
      const post = Post(
        id: 1,
        userId: 1,
        title: 'hello world',
        body: 'test',
      );

      expect(post.capitalizedTitle, 'Hello world');
    });

    test('formattedId pads with leading zeroes', () {
      const post = Post(
        id: 7,
        userId: 1,
        title: 'test',
        body: 'test',
      );

      expect(post.formattedId, '#007');
    });

    test('snippet truncates long text cleanly', () {
      const post = Post(
        id: 1,
        userId: 1,
        title: 'test',
        body:
            'This is a very long body that exceeds ninety characters in length to verify that the snippet getter properly truncates it with an ellipsis.',
      );

      expect(post.snippet.endsWith('...'), isTrue);
      expect(post.snippet.length, lessThanOrEqualTo(90));
    });

    test('equality and hashCode work as expected', () {
      const post1 = Post(id: 1, userId: 1, title: 'a', body: 'b');
      const post2 = Post(id: 1, userId: 1, title: 'a', body: 'b');
      const post3 = Post(id: 2, userId: 1, title: 'a', body: 'b');

      expect(post1, equals(post2));
      expect(post1.hashCode, equals(post2.hashCode));
      expect(post1, isNot(equals(post3)));
    });
  });
}

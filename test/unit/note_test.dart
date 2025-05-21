import 'package:flutter_test/flutter_test.dart';
import 'package:paddy/models/note.dart'; // Adjust the import path as necessary

void main() {
  group('Note Model', () {
    test('Note instantiation and property access', () {
      final timestamp = DateTime.now();
      final note = Note(
        id: 'test_id',
        title: 'Test Title',
        content: 'Test Content',
        timestamp: timestamp,
      );

      expect(note.id, 'test_id');
      expect(note.title, 'Test Title');
      expect(note.content, 'Test Content');
      expect(note.timestamp, timestamp);
    });
  });
}

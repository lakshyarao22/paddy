import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import flutter_markdown
import 'package:paddy/models/note.dart'; // Adjust path as necessary
import 'package:paddy/widgets/note_card.dart'; // Adjust path as necessary

void main() {
  group('NoteCard Widget', () {
    testWidgets('Displays note title and Markdown content', (WidgetTester tester) async {
      // Create a sample Note object
      final sampleNote = Note(
        id: 'test_id',
        title: 'Test Note Title',
        content: 'This is the *Markdown* test content of the note, which might be a bit long.',
        timestamp: DateTime.now(),
      );

      // Pump the NoteCard widget with this note inside a MaterialApp
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold( // Scaffold provides Directionality and basic Material structure
            body: NoteCard(note: sampleNote),
          ),
        ),
      );

      // Verify that the note's title is displayed
      expect(find.text('Test Note Title'), findsOneWidget);

      // Verify that MarkdownBody is present and displays the correct Markdown data
      final markdownBodyFinder = find.byType(MarkdownBody);
      expect(markdownBodyFinder, findsOneWidget);
      final MarkdownBody markdownBodyWidget = tester.widget<MarkdownBody>(markdownBodyFinder);
      expect(markdownBodyWidget.data, equals(sampleNote.content));
    });
  });
}

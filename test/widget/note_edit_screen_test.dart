import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paddy/models/note.dart'; // Adjust path
import 'package:paddy/screens/note_edit_screen.dart'; // Adjust path

void main() {
  group('NoteEditScreen Widget', () {
    // Helper function to pump NoteEditScreen within a MaterialApp
    Future<void> pumpNoteEditScreen(
      WidgetTester tester, {
      Note? note,
      required Function(String title, String content) onSave,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NoteEditScreen(note: note, onSave: onSave),
        ),
      );
    }

    testWidgets('Displays empty fields for a new note', (WidgetTester tester) async {
      await pumpNoteEditScreen(tester, onSave: (title, content) {});

      // Verify title TextField is present and empty
      final titleField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Title',
      );
      expect(titleField, findsOneWidget);
      expect(tester.widget<TextField>(titleField).controller?.text, isEmpty);

      // Verify content TextField is present and empty
      final contentField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Start writing your note here...',
      );
      expect(contentField, findsOneWidget);
      expect(tester.widget<TextField>(contentField).controller?.text, isEmpty);

      // Verify "Save" button is present
      expect(find.widgetWithText(TextButton, 'Save'), findsOneWidget);
    });

    testWidgets('Displays note data when editing an existing note', (WidgetTester tester) async {
      final note = Note(
        id: 'edit_id',
        title: 'Editable Title',
        content: 'Editable Content',
        timestamp: DateTime.now(),
      );

      await pumpNoteEditScreen(tester, note: note, onSave: (title, content) {});

      // Verify title TextField displays the note's title
      final titleField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Title',
      );
      expect(tester.widget<TextField>(titleField).controller?.text, 'Editable Title');

      // Verify content TextField displays the note's content
      final contentField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Start writing your note here...',
      );
      expect(tester.widget<TextField>(contentField).controller?.text, 'Editable Content');
    });

    testWidgets('Calls onSave callback when save button is tapped', (WidgetTester tester) async {
      bool wasOnSaveCalled = false;
      String? savedTitle;
      String? savedContent;

      await pumpNoteEditScreen(
        tester,
        onSave: (title, content) {
          wasOnSaveCalled = true;
          savedTitle = title;
          savedContent = content;
        },
      );

      // Enter some text into the title and content fields
      final titleField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Title',
      );
      await tester.enterText(titleField, 'New Title');

      final contentField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Start writing your note here...',
      );
      await tester.enterText(contentField, 'New Content');

      // Find the "Save" button and tap it
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle(); // Wait for navigation/animations

      // Expect onSave to have been called
      expect(wasOnSaveCalled, isTrue);
      expect(savedTitle, 'New Title');
      expect(savedContent, 'New Content');
    });

    testWidgets('Saves raw Markdown content', (WidgetTester tester) async {
      String rawMarkdownInput = "*bold text* and _italic_ with a # heading";
      String? capturedContent;

      await pumpNoteEditScreen(
        tester,
        onSave: (title, content) {
          capturedContent = content; // Capture the content passed to onSave
        },
      );

      // Enter raw Markdown into the content field
      final contentField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Start writing your note here...',
      );
      expect(contentField, findsOneWidget);
      await tester.enterText(contentField, rawMarkdownInput);

      // Tap the "Save" button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle(); // Wait for navigation/animations

      // Verify that the captured content is the same as the raw Markdown input
      expect(capturedContent, equals(rawMarkdownInput));
    });
  });
}

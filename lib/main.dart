import 'package:flutter/material.dart';
import 'dart:io'; // For File operations
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:paddy/models/note.dart';
import 'package:paddy/screens/note_edit_screen.dart'; // Import NoteEditScreen
import 'package:paddy/widgets/note_card.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light(); // Start with a light theme baseline

    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Paddy Notes',
        theme: baseTheme.copyWith(
          primaryColor: const Color(0xFFFDFFB6), // Light yellow, good for accents
          scaffoldBackgroundColor: const Color(0xFFFDF5E6), // Old Lace for paper feel
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFFFFF0C1), // Complementary to Old Lace
            foregroundColor: Colors.brown[800], // Dark brown for text/icons
            elevation: 1.0,
            titleTextStyle: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFDFFB6), // Primary yellow
            brightness: Brightness.light,
            background: const Color(0xFFFDF5E6), // Paper color for background
          ),
          textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme).copyWith(
            // Titles and UI elements using Lato
            displayLarge: GoogleFonts.lato(textStyle: baseTheme.textTheme.displayLarge),
            displayMedium: GoogleFonts.lato(textStyle: baseTheme.textTheme.displayMedium),
            displaySmall: GoogleFonts.lato(textStyle: baseTheme.textTheme.displaySmall),
            headlineLarge: GoogleFonts.lato(textStyle: baseTheme.textTheme.headlineLarge),
            headlineMedium: GoogleFonts.lato(textStyle: baseTheme.textTheme.headlineMedium),
            headlineSmall: GoogleFonts.lato(textStyle: baseTheme.textTheme.headlineSmall),
            titleLarge: GoogleFonts.lato(textStyle: baseTheme.textTheme.titleLarge),
            titleMedium: GoogleFonts.lato(textStyle: baseTheme.textTheme.titleMedium),
            titleSmall: GoogleFonts.lato(textStyle: baseTheme.textTheme.titleSmall),
            // Body text using Roboto Slab
            bodyLarge: GoogleFonts.robotoSlab(textStyle: baseTheme.textTheme.bodyLarge),
            bodyMedium: GoogleFonts.robotoSlab(textStyle: baseTheme.textTheme.bodyMedium),
            bodySmall: GoogleFonts.robotoSlab(textStyle: baseTheme.textTheme.bodySmall),
          ),
          useMaterial3: true,
        ),
        home: MyHomePage(title: 'Paddy Notes'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Updated notes list
  final List<Note> _notes = [
    Note(id: '1', title: 'My First Note', content: 'This is the content of my first note. It is very exciting!', timestamp: DateTime.now()),
    Note(id: '2', title: 'Shopping List', content: 'Milk, Eggs, Bread, Coffee', timestamp: DateTime.now().subtract(const Duration(days: 1))),
    Note(id: '3', title: 'Ideas for project', content: 'Think about UI, state management, and persistence.', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
  ];

  // Function to add a new note
  void _addNote(Note note) {
    setState(() {
      _notes.add(note);
    });
  }

  // Function to update an existing note
  void _updateNote(Note note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
      }
    });
  }

  // Function to delete a note
  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
  }

  // Function to show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(String noteId, String noteTitle) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the note titled "$noteTitle"?'),
                const Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red), // Make delete button red
              onPressed: () {
                _deleteNote(noteId);
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Function to export notes to Markdown
  Future<void> _exportNotesToMarkdown() async {
    // Ensure the widget is still mounted before showing SnackBars or interacting with context
    if (!mounted) return;

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Directory selection canceled.')),
        );
        return;
      }

      int successCount = 0;
      int errorCount = 0;
      for (final note in _notes) {
        final String fileName = "${note.id}.md"; // Using ID for safe filename
        final String markdownContent = "# ${note.title}\n\n${note.content}";
        final File file = File("$selectedDirectory/$fileName");

        try {
          await file.writeAsString(markdownContent);
          successCount++;
        } catch (e) {
          errorCount++;
          debugPrint('Error writing file for note ${note.id}: $e');
          // Optionally, collect errors and show a summary
        }
      }

      if (!mounted) return;
      String message = '$successCount notes exported successfully to $selectedDirectory';
      if (errorCount > 0) {
        message += '\n$errorCount notes failed to export.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    } catch (e) {
      debugPrint('Error during export: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during export: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Set AppBar title
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export Notes to Markdown',
            onPressed: _exportNotesToMarkdown,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(
                    note: note, // Pass the existing note
                    onSave: (title, content) {
                      _updateNote(Note(
                        id: note.id, // Keep original ID
                        title: title,
                        content: content,
                        timestamp: DateTime.now(), // Update timestamp
                      ));
                    },
                  ),
                ),
              );
            },
            onLongPress: () {
              _showDeleteConfirmationDialog(note.id, note.title);
            },
            child: NoteCard(note: note),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.brown.withOpacity(0.25), // Subtle brown line, slightly more transparent
            height: 1,
            thickness: 0.7, // Slightly thinner
            indent: 20, // Indent from the left
            endIndent: 20, // Indent from the right
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditScreen(
                onSave: (title, content) {
                  _addNote(Note(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    content: content,
                    timestamp: DateTime.now(),
                  ));
                },
              ),
            ),
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

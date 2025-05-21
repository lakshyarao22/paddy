import 'package:flutter/material.dart';
import 'package:paddy/models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  final Function(String title, String content)? onSave;

  const NoteEditScreen({Key? key, this.note, this.onSave}) : super(key: key);

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (widget.onSave != null) {
      widget.onSave!(title, content);
    }

    // Pop screen
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Save',
              style: GoogleFonts.lato( // Consistent with AppBar title style
                color: Colors.brown[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Ensure paper background
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), // Adjust top padding
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none, // Minimalist look
                hintStyle: GoogleFonts.lato(color: Colors.brown[300], fontSize: 22, fontWeight: FontWeight.bold),
              ),
              style: GoogleFonts.lato( // Title font
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 8.0), // Reduced space
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Start writing your note here...',
                  border: InputBorder.none, // Minimalist look
                  hintStyle: GoogleFonts.robotoSlab(color: Colors.brown[300], fontSize: 16),
                  alignLabelWithHint: true,
                ),
                style: GoogleFonts.robotoSlab( // Content font
                  fontSize: 16,
                  color: Colors.brown[700],
                  height: 1.5, // Improved line spacing for readability
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import flutter_markdown
import 'package:google_fonts/google_fonts.dart'; // Ensure GoogleFonts is imported
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF0C1), // A slightly more saturated yellow than background
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2.0, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        // side: BorderSide(color: Colors.brown.withOpacity(0.2), width: 1), // Optional subtle border
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: GoogleFonts.lato( // Title font from theme
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 8.0),
            // Replace Text widget with MarkdownBody
            MarkdownBody(
              data: note.content, // Using full content as per initial instruction
              // Applying styleSheet to maintain consistency with the theme
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: GoogleFonts.robotoSlab().fontFamily,
                      fontSize: 14.0,
                      color: Colors.brown[700],
                    ),
                // Example for other tags if needed, but keeping it simple for now
                // h1: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: GoogleFonts.lato().fontFamily),
                // listBullet: TextStyle(fontFamily: GoogleFonts.robotoSlab().fontFamily, fontSize: 14.0, color: Colors.brown[700]),
              ),
              // Note: MarkdownBody does not have a direct maxLines or overflow property.
              // Truncation would need to happen on the `data` string itself if strict line limits are needed.
              // For now, allowing it to render and relying on card constraints.
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ClefsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text(
          'Clefs',
          style: TextStyle(
            color: Color(0xFF753027),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFE4E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF753027)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What are clef note?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'A clef note is a symbol that is placed at the left-hand end of a staff, indicating the pitch of the notes written on it. It is essential for a musician to be able to read the music in front of them, as it tells them which lines or spaces represent each note. There are many types of clefs, but the four that are regularly used in modern music are Treble, Bass, Alto, and Tenor.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Treble Clef',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The treble clef is also called the “G clef” because the symbol at the beginning of the staff (a stylized letter “G”) encircles the second line of the staff, indicating that line to be G4 (or G above middle C). It is the most commonly used clef today and is usually the first clef that musicians learn on their music theory journey.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'The treble clef is represented by the following symbol:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/treble_clef.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'When the treble clef is indicated, the lines and spaces represent the following notes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/treble_clef_with_note.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bass Clef',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The bass clef is also called an F clef because it wraps around the highest F note on the bass staff. It is usually the second clef that musicians learn after treble, as it is placed on the bottom staff in the grand staff for piano.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'The bass clef is represented by the following symbol:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/bass_clef.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'When the bass clef is indicated, the lines and spaces represent the following notes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/bass_clef_with_note.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Alto Clef',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The alto clef is one of many “C clefs” and is named as such because its center indicates middle C. The alto clef center is placed on directly in the middle of the staff, designating the third line from the bottom to middle C.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'The alto clef is represented by the following symbol:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/alto_clef.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'When the alto clef is indicated, the lines and spaces represent the following notes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/alto_clef_with_note.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tenor Clef',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The tenor clef is another type of “C clef,” however its center is on the fourth line from the bottom, so middle C is moved up a third from where it was on the alto clef. ',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'The tenor clef is represented by the following symbol:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/tenor_clef.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'When the tenor clef is indicated, the lines and spaces represent the following notes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/symbols/tenor_clef_with_note.png', // Update with your image path
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

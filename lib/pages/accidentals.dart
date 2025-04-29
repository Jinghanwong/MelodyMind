import 'package:flutter/material.dart';

class AccidentalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text(
          'Accidentals',
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
              'An accidental is a symbol in music notation that raises or lowers a natural note by one or two half steps. The accidental changes the pitch, so that the note is either higher or lower than the original natural note. Accidentals are written in front of the notes, but in text, accidentals are written after the note names.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '1. The five accidentals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'There are five different accidentals:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/sharp.PNG',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A sharp raises a note by a half step. Instead of the original note, you should play the note that is a half step above (on the right of the piano).',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/flat.PNG',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A flat lowers a note by a half step. Instead of the original note, you should play the note that is a half step below (on the left of the piano).',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/double_sharp.PNG',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A double-sharp raises a note by two half steps. Instead of the original note, you should play the note that is two half steps above (on the right of the piano).',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/double_flat.PNG',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A double-flat lowers a note by two half steps. Instead of the original note, you should play the note that is two half steps below (on the left of the piano).',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/natural.PNG',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '	A natural cancels the effect of another accidental.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '2. Accidental notes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'A note with a sharp (♯) is played a half step above the original note. The seven sharp notes are C♯ (pronounced "C-sharp"), D♯, E♯, F♯, G♯, A♯, and B♯:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/sharp_notes.PNG',
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'A note with a flat (♭) is played a half step below the original note. The seven flat notes are C♭ (pronounced "C-flat"), D♭, E♭, F♭, G♭, A♭, and B♭:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/flat_notes.PNG',
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'A note with a double-sharp (𝄪) is played two half steps above the original note. The seven double-sharp notes are C ("C-double-sharp"), D𝄪, E𝄪, F𝄪, G𝄪, A𝄪, and B𝄪:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/double_sharp_notes.PNG',
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'A note with a double-flat (♭♭) is played two half steps below the original note. The seven double-flat notes are C♭♭ ("C-double-flat"), D♭♭, E♭♭, F♭♭, G♭♭, A♭♭, and B♭♭:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/symbols/double_flat_notes.PNG',
                    fit: BoxFit.contain,
                    height: 200,
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

import 'package:flutter/material.dart';

class KeySignaturesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text(
          'Key Signatures',
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
              'A key signature is placed at the beginning of a piece (or the beginning of a section) and is written with the clef on the beginning of each line of music. The key signature reminds the performer which sharps or flats are in the scale (or key) of the piece and prevents the composer or arranger from writing every sharp or flat from the scale every time it occurs.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'There are 15 major key signatures. The key of C major has no sharps or flats in the key signature. The other key signatures can have between 1 to 7 sharps and 1 to 7 flats, giving us the other 14 key signatures.',
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
                    'assets/images/symbols/key_sharp.png',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Key Signatures using Sharps',
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
                    'assets/images/symbols/key_flat.png',
                    fit: BoxFit.contain,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Key Signatures using Flats',
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
              'The order of sharps is F-C-G-D-A-E-B, often remembered by a mnemonic. One common mnemonic for the order of sharps is “Fast Cars Go Dangerously Around Every Bend.”',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'The order of flats is B-E-A-D-G-C-F. It is the reverse of the order of sharps. It is easy to remember since the first four letters make the word BEAD, and GCF is something most students learn as “Greatest Common Factor” when studying math in elementary school.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'A helpful learning device to remember the order of keys in relation to the order of sharps and flats is the circle of fifths. As you ascend in fifths (clockwise), key signatures get one degree “sharper.” (C to G is a fifth because C=1, D=2, E=3, F=4, and G=5). As you descend in fifths (counterclockwise), key signatures get one degree “flatter”.',
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
                    'assets/images/symbols/circle_of_fifths_major.png',
                    fit: BoxFit.contain,
                    height: 300,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Circle of Fifths for Major Keys',
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
            const Text(
              'Note the overlapping keys at the bottom of the circle. B major is enharmonically the same as C♭ major, F♯ major is enharmonically the same as G♭ major, and C♯ major is enharmonically the same as D♭ major.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

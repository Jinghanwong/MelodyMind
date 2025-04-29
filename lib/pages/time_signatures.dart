import 'package:flutter/material.dart';

class TimeSignaturesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text(
          'Time Signatures',
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
              'What are time signatures?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Time signatures, or meter, are the notations in sheet music that guide the rhythmic structure of a piece. They appear at the start of a piece of music, with the clef and key signature, to let musicians know how to count before they start playing. They give instructions on how to divide and feel the rhythmic pulse of a tune ensuring written sheet music sounds as intended.',
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
                    'Time signature',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/time_signature.jpg',
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'How to read a time signature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sheet music is split up into bars. Each bar of music is shown by bar lines which help musicians visualize and divide the piece into chunks and phrases. Barlines are vertical lines drawn through the staff and contain a set number of beats dictated by the time signature.',
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
                    'A measure line',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Removed container, keeping just the image
                  Image.asset(
                    'assets/images/measure_line.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'When reading a time signature, the top number of a time signature tells you how many of a certain type of beats there are in a bar. The bottom number denotes the value of those beats. For example 4/4 means four quarter notes in a bar. Just like a fraction.',
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
                  Image.asset(
                    'assets/images/time_signature_explanation.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Here is a quick cheat sheet:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF9A9E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Bottom number',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Note value',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTableRow('2', 'Half beats'),
                  _buildTableRow('4', 'Quarter beats'),
                  _buildTableRow('8', 'Eighth beats'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildBulletPoint(
                '4/4 means there are 4 beats in each measure and a quarter note receives one count.'),
            _buildBulletPoint(
                '2/4 means there are 2 beats in each measure and a quarter note receives one count.'),
            _buildBulletPoint(
                '2/2 means there are 2 beats in each measure and a half note receives one count.'),
            _buildBulletPoint(
                '6/8 means there are 6 beats in each measure and an eighth note receives one count.'),
            const SizedBox(height: 24),
            const Text(
              'Common time signatures',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Just as a language has its popular phrases and works, music has some more prevalent time signatures. These common time signatures form the rhythmic backbone of much of the music we hear.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '4/4 time signature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Often referred to as "common time", the 4/4 time signature is the most widely used in Western music. It is used so often that it can also be represented as a "C" in place of the usual numbers.',
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
                  Image.asset(
                    'assets/images/4-4-time-signature.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'In 4/4. There are four beats in each measure, and each beat corresponds to a quarter note. It is the pulse behind many of your favorite pop songs, and it is easy to count one, two, three, four, repeat. The 4/4 time signature gives music a steady, perfect for getting your foot tapping.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '“C” time signature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you see a mysterious “C” at the beginning of your sheet music, do not panic. This is just another way of representing the 4/4 time signature. The “C” stands for “common time,” reinforcing just how ubiquitous this time signature is. It is the same four beats per measure, with the quarter note getting the beat.',
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
                  Image.asset(
                    'assets/images/C-time-signature.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '2/2 time signature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Moving on to the 2/2 time signature, also known as “cut time” or “alla breve.” This time signature has two beats per measure, with a half note equivalent to one beat. It “cuts” the common time in half. It is common in faster pieces as it allows musicians to read and play rapid passages more easily due to larger, easier to read, values of beat divisions. It sounds almost the same as 4/4 except it has a stronger accent on the 3rd beat of each measure (the second half note).',
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
                  Image.asset(
                    'assets/images/2-2-time-signature.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cut time also has an abbreviation that looks like the common time symbol, but with a vertical line cutting through it:',
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
                  Image.asset(
                    'assets/images/abbreviation.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '2/4 time signature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The 2/4 time signature is another frequently seen time signature, featuring two beats per measure, with the quarter note getting one beat. It is a lively time signature that is particularly popular in polkas, marches and other dance music genres. If you have ever danced to a catchy two-step beat, you have felt the pulse of the 2/4 time signature.',
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
                  Image.asset(
                    'assets/images/2-4-time-signature.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '3/4 time signature',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This time signature gives us three beats per measure, with the quarter note getting one beat. It is the signature behind the graceful waltz and many folk and pop songs. If you count a rhythmic one-two-three, one-two-three, you are feeling the sway of the 3/4 time. This time signature relies on an accented first beat followed by two active beats, giving this time signature its distinctive sway.',
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
                  Image.asset(
                    'assets/images/3-4-time-signature.jpg', // Update with your image path
                    fit: BoxFit.contain,
                    height: 130,
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

  Widget _buildTableRow(String number, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF753027),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TimeNamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text(
          'Time Names',
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
              'Every note has a time value. Time values are measured in beats.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF753027),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 3),
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
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Time Names and Time Values',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(1.5),
                    },
                    children: [
                      _buildTableHeader(),
                      _buildTableRow('4', 'semibreve\n(whole note)', _buildCustomSymbol(1)),
                      _buildTableRow('2', 'minim\n(half note)', _buildCustomSymbol(2)),
                      _buildTableRow('1', 'crotchet\n(quarter note)', _buildCustomSymbol(3)),
                      _buildTableRow('1/2', 'quaver\n(eighth note)', _buildCustomSymbol(4)),
                      _buildTableRow('1/4', 'semiquaver\n(sixteenth note)', _buildCustomSymbol(5)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAD0C4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Did you know?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF753027),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The time value of a note tells you how long to play or sing it. Each note\'s value is relative to the others - a minim is half the length of a semibreve, a crotchet is half the length of a minim, and so on.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF753027),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
      ),
      children: [
        _buildHeaderCell('Time\nvalue'),
        _buildHeaderCell('Time name'),
        _buildHeaderCell('Note'),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF753027),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String timeValue, String timeName, Widget noteWidget) {
    return TableRow(
      children: [
        _buildValueCell(timeValue),
        _buildNameCell(timeName),
        _buildNoteCell(noteWidget),
      ],
    );
  }

  Widget _buildValueCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildNameCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildNoteCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(child: child),
    );
  }

  // Note symbols using custom widgets that match your images
  Widget _buildCustomSymbol(int imageNumber) {
  // Replace these paths with the actual paths to your note images
  String imagePath;
  switch (imageNumber) {
    case 1:
      imagePath = 'assets/images/symbols/semibreve.png'; // whole note image
      break;
    case 2:
      imagePath = 'assets/images/symbols/minims.png'; // half note image
      break;
    case 3:
      imagePath = 'assets/images/symbols/crotchets.png'; // quarter note image
      break;
    case 4:
      imagePath = 'assets/images/symbols/quavers.png'; // eighth note image
      break;
    case 5:
      imagePath = 'assets/images/symbols/semiquavers.png'; // sixteenth note image
      break;
    default:
      imagePath = 'assets/images/symbols/default.png';
  }
  
  return Image.asset(
    imagePath,
    width: 60,
    height: 50,
    fit: BoxFit.contain,
  );
}
}

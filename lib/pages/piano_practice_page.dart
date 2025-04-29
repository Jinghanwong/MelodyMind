import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class PianoPracticePage extends StatefulWidget {
  @override
  _PianoPracticePageState createState() => _PianoPracticePageState();
}

class _PianoPracticePageState extends State<PianoPracticePage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  String? pressedKey;
  
  @override
  void initState() {
    super.initState();
    // Force landscape orientation when entering this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  @override
  void dispose() {
    // Return to normal orientation when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set white key width as a constant for consistent calculations
    const double whiteKeyWidth = 70.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Same background as the previous screen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF753027)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Piano Practice',
          style: TextStyle(
            color: Color(0xFF753027),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 270, // Fixed height for the piano container
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF753027).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildWhiteKey('C'),
                      buildWhiteKey('D'),
                      buildWhiteKey('E'),
                      buildWhiteKey('F'),
                      buildWhiteKey('G'),
                      buildWhiteKey('A'),
                      buildWhiteKey('B'),
                      buildWhiteKey('C'),
                    ],
                  ),
                  Positioned(
                    left: whiteKeyWidth - 20, // Between C and D
                    child: buildBlackKey('C#', 'Db'),
                  ),
                  Positioned(
                    left: 2 * whiteKeyWidth - 20, // Between D and E
                    child: buildBlackKey('D#', 'Eb'),
                  ),
                  Positioned(
                    left: 4 * whiteKeyWidth - 20, // Between F and G
                    child: buildBlackKey('F#', 'Gb'),
                  ),
                  Positioned(
                    left: 5 * whiteKeyWidth - 20, // Between G and A
                    child: buildBlackKey('G#', 'Ab'),
                  ),
                  Positioned(
                    left: 6 * whiteKeyWidth - 20, // Between A and B
                    child: buildBlackKey('A#', 'Bb'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWhiteKey(String note) {
    bool isPressed = pressedKey == note;
    return GestureDetector(
      onTap: () {
        playSound(note);
        setState(() {
          pressedKey = note;
        });
        // Reset the pressedKey after a short delay
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            if (pressedKey == note) {
              pressedKey = null;
            }
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 70, // Fixed width for consistent positioning
        height: isPressed ? 220 : 230,
        margin: EdgeInsets.only(top: isPressed ? 10 : 0),
        decoration: BoxDecoration(
          color: isPressed ? Colors.grey[300] : Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              note,
              style: TextStyle(
                fontSize: 20.0, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF753027),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlackKey(String note1, String note2) {
    bool isPressed = pressedKey == note1;
    return GestureDetector(
      onTap: () {
        playSound(note1);
        setState(() {
          pressedKey = note1;
        });
        // Reset the pressedKey after a short delay
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            if (pressedKey == note1) {
              pressedKey = null;
            }
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 40,
        height: isPressed ? 125 : 135,
        margin: EdgeInsets.only(top: isPressed ? 10 : 0),
        decoration: BoxDecoration(
          color: isPressed ? Colors.grey[800] : Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '$note1/$note2',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0, 
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void playSound(String note) async {
    try {
      String path = 'sounds/${note.replaceAll('#', 's')}.mp3';
      if (kIsWeb) {
        String url = await getUrlFromAsset(path);
        await audioPlayer.play(UrlSource(url));
      } else {
        await audioPlayer.play(AssetSource(path));
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<String> getUrlFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List().toList();
    final base64String = base64Encode(bytes);
    final String url = 'data:audio/mp3;base64,$base64String';
    return url;
  }
}
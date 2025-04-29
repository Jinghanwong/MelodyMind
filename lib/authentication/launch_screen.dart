import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/authentication/login_page.dart';
import 'package:fyp/pages/music_main_page.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 800), () {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        fetchUserDataAndNavigate(currentUser.uid);
      }
    });
  }

  void fetchUserDataAndNavigate(String uid) async {
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(uid);
      
      DataSnapshot snapshot = await userRef.get();
      
      if (snapshot.exists) {
        Map<dynamic, dynamic>? userData = snapshot.value as Map?;
        String name = userData?['username'] ?? 'User';
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MusicMainPage(name: name),
          ),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              child: Image.asset(
                'assets/images/piano_rb.png',
                width: screenWidth * 1.0,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'MelodyMind',
              style: TextStyle(
                fontSize: screenWidth * 0.09,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF753027),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Master the art of music,\none note at a time',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: const Color(0xFF753027),
                height: 1.5,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            ElevatedButton(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  fetchUserDataAndNavigate(FirebaseAuth.instance.currentUser!.uid);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xBFD99898),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
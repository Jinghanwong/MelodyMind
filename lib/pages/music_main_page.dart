import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/authentication/login_page.dart';
import 'package:fyp/pages/ear_training_page1.dart';
import 'package:fyp/pages/edit_profile_page.dart';
import 'package:fyp/pages/music_theory_page.dart';
import 'package:fyp/pages/piano_practice_page.dart';
import 'package:fyp/pages/quiz_music_theory_page.dart';
import 'package:fyp/pages/quiz_result_page.dart';

class MusicMainPage extends StatefulWidget {
  final String name;

  const MusicMainPage({Key? key, required this.name}) : super(key: key);

  @override
  State<MusicMainPage> createState() => _MusicMainPageState();
}

class _MusicMainPageState extends State<MusicMainPage> {
  late String currentName;

  @override
  void initState() {
    super.initState();
    currentName = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEBEB),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFDEBEB),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.black87),
              title: const Text(
                'Quiz Result',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizResultPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black87),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Log Out Confirmation'),
                      content: const Text(
                          'Are you sure you want to log out from current account?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); 
                            await FirebaseAuth.instance
                                .signOut(); 
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (Route<dynamic> route) => false, 
                            );
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          // Wrap IconButton with Builder
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              
              if (result != null && result is String) {
                setState(() {
                  currentName = result;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF753027),
                        ),
                      ),
                      Text(
                        currentName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF753027),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/notes_rb.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Learn Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learn',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            'Music\nTheory',
                            'assets/images/piano_rb.png',
                            'Lesson',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicTheoryPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildCard(
                            'Piano\nInteractive',
                            'assets/images/soundofnote_rb.png',
                            'Lesson',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PianoPracticePage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // Quiz Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quiz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            'Music\nTheory',
                            'assets/images/quiz_rb.png',
                            'Challenge',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizMusicTheoryPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildCard(
                            'Ear\nTraining',
                            'assets/images/eartraning_rb.png',
                            'Challenge',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EarTrainingPage1(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String imagePath, String label,
      {Function? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: 200, // Increased height for larger content
        decoration: BoxDecoration(
          color: Color(0xBFD99898),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: double.infinity, // Make image fill the width
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF753027),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fyp/pages/quiz_ear_training1.dart';
import 'package:fyp/pages/quiz_ear_training2.dart';
import 'package:fyp/pages/quiz_ear_training3.dart';

class EarTrainingPage1 extends StatelessWidget {
  final List<LevelItem> levels = [
    LevelItem(
      title: 'Easy',
      description: 'Perfect for beginners\nStart your ear training journey',
      gradient: [Color(0xFF7FD8FF), Color(0xFF4E97FF)],
      icon: Icons.light_mode,
    ),
    LevelItem(
      title: 'Intermediate',
      description: 'For intermediate learners\nEnhance your musical skills',
      gradient: [Color(0xFFFF9D9D), Color(0xFFFF5B5B)],
      icon: Icons.auto_awesome,
    ),
    LevelItem(
      title: 'Advanced',
      description: 'Challenge yourself\nMaster your ear training',
      gradient: [Color(0xFFB47EFF), Color(0xFF8534FF)],
      icon: Icons.workspace_premium,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF753027)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ear Training',
          style: TextStyle(
            color: Color(0xFF753027),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Please select the level of ear training',
              style: TextStyle(
                color: Color(0xFF753027),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildLevelCard(context, levels[index], index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, LevelItem level, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to specific QuizEarTraining pages based on the selected level
        switch (index) {
          case 0: // Easy
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizEarTraining1()),
            );
            break;
          case 1: // Intermediate
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizEarTraining2()),
            );
            break;
          case 2: // Hard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizEarTraining3()),
            );
            break;
        }
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: level.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: level.gradient[1].withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      level.icon,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          level.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          level.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
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
}

class LevelItem {
  final String title;
  final String description;
  final List<Color> gradient;
  final IconData icon;

  LevelItem({
    required this.title,
    required this.description,
    required this.gradient,
    required this.icon,
  });
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class QuizEarTraining1 extends StatefulWidget {
  const QuizEarTraining1({Key? key}) : super(key: key);

  @override
  _QuizEarTraining1State createState() => _QuizEarTraining1State();
}

class _QuizEarTraining1State extends State<QuizEarTraining1> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  List<int> _userAnswers = List.filled(10, -1);
  List<EarQuestion> _questions = [];
  final Random _random = Random();

  // Track if current question is answered
  bool _currentQuestionAnswered = false;
  // Store the user's selected answer index
  int _selectedAnswerIndex = -1;
  
  // Audio players
  final AudioPlayer _questionAudioPlayer = AudioPlayer();
  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _incorrectSoundPlayer = AudioPlayer();

  // List of white keys to use in our quiz
  final List<String> whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  // Play correct answer sound
  void _playCorrectSound() async {
    await _correctSoundPlayer.play(AssetSource('sounds/correct.mp3'));
  }
  
  // Play incorrect answer sound
  void _playIncorrectSound() async {
    await _incorrectSoundPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  // Play the note sound
  void _playNoteSound(String note) async {
    try {
      await _questionAudioPlayer.play(AssetSource('sounds/$note.mp3'));
    } catch (e) {
      print('Error playing note sound: $e');
    }
  }

  @override
  void dispose() {
    _questionAudioPlayer.dispose();
    _correctSoundPlayer.dispose();
    _incorrectSoundPlayer.dispose();
    super.dispose();
  }

  void _generateQuestions() {
    final List<EarQuestion> questions = [];
    
    for (int i = 0; i < 10; i++) {
      // Select a correct answer from white keys
      final int correctNoteIndex = _random.nextInt(whiteKeys.length);
      final String correctNote = whiteKeys[correctNoteIndex];
      
      // Create wrong options by selecting two different notes
      final List<String> options = [correctNote];
      while (options.length < 3) {
        final String randomNote = whiteKeys[_random.nextInt(whiteKeys.length)];
        if (!options.contains(randomNote)) {
          options.add(randomNote);
        }
      }
      
      // Shuffle options to randomize the position of the correct answer
      options.shuffle(_random);
      
      // Find the index of the correct answer in the shuffled options
      final int correctOptionIndex = options.indexOf(correctNote);
      
      // Create the question
      questions.add(
        EarQuestion(
          correctNote: correctNote,
          options: options,
          correctOptionIndex: correctOptionIndex,
        )
      );
    }

    setState(() {
      _questions = questions;
    });
  }

  void _answerQuestion(int selectedOptionIndex) {
    if (_currentQuestionIndex < _questions.length && !_currentQuestionAnswered) {
      setState(() {
        _userAnswers[_currentQuestionIndex] = selectedOptionIndex;
        _selectedAnswerIndex = selectedOptionIndex;
        _currentQuestionAnswered = true;
        
        if (selectedOptionIndex == _questions[_currentQuestionIndex].correctOptionIndex) {
          _score++;
          _playCorrectSound();
          
          Future.delayed(const Duration(milliseconds: 800), () {
            if (_currentQuestionIndex < _questions.length - 1) {
              _moveToNextQuestion();
            } else {
              _completeQuiz();
            }
          });
        } else {
          _playIncorrectSound();
        }
      });
    }
  }
  
  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _currentQuestionAnswered = false;
        _selectedAnswerIndex = -1;
      });
    } else {
      _completeQuiz();
    }
  }
  
  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
      _saveQuizResults();
    });
  }

  void _saveQuizResults() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final percentage = (_score / 10 * 100).toInt();
        final dateStr = _getCurrentDate();
        
        await FirebaseDatabase.instance
            .ref()
            .child('quiz_results')
            .child(user.uid)
            .push()
            .set({
              'quiz_type': 'Easy',
              'score': _score,
              'total_questions': 10,
              'percentage': percentage,
              'date': dateStr,
              'timestamp': ServerValue.timestamp,
            });
      }
    } catch (e) {
      print('Error saving quiz results: $e');
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year.toString().substring(2)}';
  }

  void _restartQuiz() {
    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _quizCompleted = false;
      _userAnswers = List.filled(10, -1);
      _currentQuestionAnswered = false;
      _selectedAnswerIndex = -1;
      _generateQuestions();
    });
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (_quizCompleted) {
      return true;
    }
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Exit Quiz?',
          style: TextStyle(
            color: Color(0xFF753027),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to exit? Your progress will not be saved.',
          style: TextStyle(
            color: Color(0xFF753027),
          ),
        ),
        backgroundColor: const Color(0xFFFFF0F5),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color(0xFF753027),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF753027),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmationDialog,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF0F5),
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text(
            'Easy Quiz',
            style: TextStyle(
              color: Color(0xFF753027),
              fontWeight: FontWeight.bold,
              fontSize: 20, 
            ), 
            maxLines: 2, 
            overflow: TextOverflow.visible, 
            textAlign: TextAlign.center, 
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFFFE4E1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF753027)),
            onPressed: () async {
              if (await _showExitConfirmationDialog()) {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAD0C4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Score: $_score/10',
                style: const TextStyle(
                  color: Color(0xFF753027),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: _quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildQuizScreen() {
    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final EarQuestion currentQuestion = _questions[_currentQuestionIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
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
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      'Question ${_currentQuestionIndex + 1} of 10',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Identify the note you hear:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF753027),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _playNoteSound(currentQuestion.correctNote),
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Play Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF753027),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._buildOptions(currentQuestion),
          
          // Display correct answer and next button section
          if (_currentQuestionAnswered && 
              _selectedAnswerIndex != currentQuestion.correctOptionIndex)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    border: Border.all(color: const Color(0xFFFF9A9E), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correct Answer:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF753027),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion.options[currentQuestion.correctOptionIndex],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF753027),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _playNoteSound(currentQuestion.correctNote),
                          icon: const Icon(Icons.volume_up, size: 16),
                          label: const Text('Play Correct Note'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF753027),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Next question button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton.icon(
                    onPressed: _moveToNextQuestion,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      _currentQuestionIndex < _questions.length - 1 
                          ? 'Next Question' 
                          : 'Finish Quiz'
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF753027),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions(EarQuestion question) {
    final List<Widget> optionWidgets = [];
    
    for (int i = 0; i < question.options.length; i++) {
      final String option = question.options[i];
      final String label = String.fromCharCode(65 + i); // A, B, C
      
      // Determine button color
      Color backgroundColor;
      Color foregroundColor;
      
      if (_currentQuestionAnswered) {
        if (i == question.correctOptionIndex) {
          // Correct answer
          backgroundColor = const Color(0xFFD4EDDA);
          foregroundColor = const Color(0xFF155724);
        } else if (i == _selectedAnswerIndex) {
          // User's incorrect answer
          backgroundColor = const Color(0xFFF8D7DA);
          foregroundColor = const Color(0xFF721C24);
        } else {
          // Other options
          backgroundColor = const Color(0xFFFAD0C4);
          foregroundColor = const Color(0xFF753027);
        }
      } else {
        // Question not answered yet
        backgroundColor = const Color(0xFFFAD0C4);
        foregroundColor = const Color(0xFF753027);
      }
      
      optionWidgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            onPressed: _currentQuestionAnswered ? null : () => _answerQuestion(i),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // Keep same colors when disabled
              disabledBackgroundColor: backgroundColor,
              disabledForegroundColor: foregroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '$label. ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    return optionWidgets;
  }

  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9A9E),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: const Center(
                    child: Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Your Score: $_score out of 10',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF753027),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getScoreMessage(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF753027),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _restartQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF753027),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage() {
    if (_score == 10) {
      return 'Perfect! You have an amazing ear for music!';
    } else if (_score >= 8) {
      return 'Great job! You have excellent pitch recognition!';
    } else if (_score >= 6) {
      return 'Good work! Keep practicing to improve your ear training skills.';
    } else if (_score >= 4) {
      return 'You\'re making progress! Regular practice will help train your ear.';
    } else {
      return 'Keep practicing! Ear training takes time to develop.';
    }
  }
}

// Question class for ear training
class EarQuestion {
  final String correctNote;
  final List<String> options;
  final int correctOptionIndex;

  EarQuestion({
    required this.correctNote,
    required this.options,
    required this.correctOptionIndex,
  });
}
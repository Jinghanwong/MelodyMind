import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class QuizClefsPage extends StatefulWidget {
  const QuizClefsPage({Key? key}) : super(key: key);

  @override
  _QuizClefsPageState createState() => _QuizClefsPageState();
}

class _QuizClefsPageState extends State<QuizClefsPage> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  List<int> _userAnswers = List.filled(10, -1);
  List<Question> _questions = [];
  final Random _random = Random();

  bool _currentQuestionAnswered = false;
  int _selectedAnswerIndex = -1;
  
  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _incorrectSoundPlayer = AudioPlayer();

  final List<ClefInfo> _clefsInfo = [
    ClefInfo(
      name: 'Treble Clef (G Clef)', 
      description: 'Indicates that the second line from the bottom is G4 (G above middle C)', 
      imagePath: 'assets/images/symbols/treble_clef.png',
      notesImagePath: 'assets/images/symbols/treble_clef_with_note.png',
    ),
    ClefInfo(
      name: 'Bass Clef (F Clef)', 
      description: 'Indicates that the second line from the top is F3 (F below middle C)', 
      imagePath: 'assets/images/symbols/bass_clef.png',
      notesImagePath: 'assets/images/symbols/bass_clef_with_note.png',
    ),
    ClefInfo(
      name: 'Alto Clef (C Clef)', 
      description: 'Indicates that the middle line is C4 (middle C)', 
      imagePath: 'assets/images/symbols/alto_clef.png',
      notesImagePath: 'assets/images/symbols/alto_clef_with_note.png',
    ),
    ClefInfo(
      name: 'Tenor Clef (C Clef)', 
      description: 'Indicates that the fourth line from the bottom is C4 (middle C)', 
      imagePath: 'assets/images/symbols/tenor_clef.png',
      notesImagePath: 'assets/images/symbols/tenor_clef_with_note.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }
  
  void _playCorrectSound() async {
    await _correctSoundPlayer.play(AssetSource('sounds/correct.mp3'));
  }
  
  void _playIncorrectSound() async {
    await _incorrectSoundPlayer.play(AssetSource('sounds/incorrect.mp3'));
  }

  @override
  void dispose() {
    _correctSoundPlayer.dispose();
    _incorrectSoundPlayer.dispose();
    super.dispose();
  }

  void _generateQuestions() {
    final List<Question> questions = [];
    final List<QuestionType> types = [
      QuestionType.imageToName,
      QuestionType.imageToDescription,
      QuestionType.nameToImage,
      QuestionType.descriptionToImage,
      QuestionType.nameToDescription,
      QuestionType.descriptionToName,
    ];

    for (int i = 0; i < 10; i++) {
      final QuestionType type = types[_random.nextInt(types.length)];
      
      final int correctClefIndex = _random.nextInt(_clefsInfo.length);
      
      final List<int> wrongIndices = [];
      while (wrongIndices.length < 2) {
        final int index = _random.nextInt(_clefsInfo.length);
        if (index != correctClefIndex && !wrongIndices.contains(index)) {
          wrongIndices.add(index);
        }
      }

      final Question question = _createQuestion(
        type: type,
        correctClefIndex: correctClefIndex,
        wrongIndices: wrongIndices,
      );
      
      questions.add(question);
    }

    setState(() {
      _questions = questions;
    });
  }

  Question _createQuestion({
    required QuestionType type,
    required int correctClefIndex,
    required List<int> wrongIndices,
  }) {
    String question;
    List<String> options = [];
    
    final ClefInfo correctClef = _clefsInfo[correctClefIndex];
    final ClefInfo wrongClef1 = _clefsInfo[wrongIndices[0]];
    final ClefInfo wrongClef2 = _clefsInfo[wrongIndices[1]];
    
    switch (type) {
      case QuestionType.imageToName:
        question = 'What is the name of this clef?';
        options = [correctClef.name, wrongClef1.name, wrongClef2.name];
        break;
      
      case QuestionType.imageToDescription:
        question = 'What does this clef indicate?';
        options = [correctClef.description, wrongClef1.description, wrongClef2.description];
        break;
      
      case QuestionType.nameToImage:
        question = 'Which symbol represents the ${correctClef.name}?';
        options = [correctClef.imagePath, wrongClef1.imagePath, wrongClef2.imagePath];
        break;
      
      case QuestionType.descriptionToImage:
        question = 'Which clef ${correctClef.description}?';
        options = [correctClef.imagePath, wrongClef1.imagePath, wrongClef2.imagePath];
        break;
      
      case QuestionType.nameToDescription:
        question = 'What does the ${correctClef.name} indicate?';
        options = [correctClef.description, wrongClef1.description, wrongClef2.description];
        break;
      
      case QuestionType.descriptionToName:
        question = 'What is the name of the clef that ${correctClef.description}?';
        options = [correctClef.name, wrongClef1.name, wrongClef2.name];
        break;
    }
    
    final List<String> shuffledOptions = [...options];
    shuffledOptions.shuffle(_random);
    
    final int correctOptionIndex = shuffledOptions.indexOf(options[0]);
    
    return Question(
      type: type,
      question: question,
      options: shuffledOptions,
      correctOptionIndex: correctOptionIndex,
      clefImage: type == QuestionType.imageToName || type == QuestionType.imageToDescription 
          ? correctClef.imagePath 
          : null,
    );
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
  
  // 完成测验的方法
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
              'quiz_type': 'Clefs',
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

  // Helper method to get current date in a readable format
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
            'Clefs Quiz',
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

    final Question currentQuestion = _questions[_currentQuestionIndex];
    
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
                Text(
                  currentQuestion.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF753027),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (currentQuestion.clefImage != null)
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      currentQuestion.clefImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._buildOptions(currentQuestion),
          
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
                      _buildCorrectAnswerWidget(currentQuestion),
                    ],
                  ),
                ),
                
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
  
  Widget _buildCorrectAnswerWidget(Question question) {
    final correctOption = question.options[question.correctOptionIndex];
    
    if (_isImagePath(correctOption)) {
      return Center(
        child: Image.asset(
          correctOption,
          height: 60,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Text(
        correctOption,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF753027),
        ),
      );
    }
  }

  List<Widget> _buildOptions(Question question) {
    final List<Widget> optionWidgets = [];
    
    for (int i = 0; i < question.options.length; i++) {
      final String option = question.options[i];
      final String label = String.fromCharCode(65 + i); // A, B, C
      
      Color backgroundColor;
      Color foregroundColor;
      
      if (_currentQuestionAnswered) {
        if (i == question.correctOptionIndex) {
          // 正确答案
          backgroundColor = const Color(0xFFD4EDDA);
          foregroundColor = const Color(0xFF155724);
        } else if (i == _selectedAnswerIndex) {
          // 用户选择的错误答案
          backgroundColor = const Color(0xFFF8D7DA);
          foregroundColor = const Color(0xFF721C24);
        } else {
          // 其他选项
          backgroundColor = const Color(0xFFFAD0C4);
          foregroundColor = const Color(0xFF753027);
        }
      } else {
        // 问题尚未回答
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
              // 禁用时保持相同颜色
              disabledBackgroundColor: backgroundColor,
              disabledForegroundColor: foregroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isImagePath(option)
                ? Row(
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
                          child: Image.asset(
                            option,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Text(
                        '$label. ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
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

  bool _isImagePath(String text) {
    return text.contains('assets/images/');
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
      return 'Perfect! You\'re a music notation expert!';
    } else if (_score >= 8) {
      return 'Great job! You have a solid understanding of music clefs.';
    } else if (_score >= 6) {
      return 'Good work! Keep practicing to improve your knowledge of clefs.';
    } else if (_score >= 4) {
      return 'You\'re getting there! A bit more practice will help you master clefs.';
    } else {
      return 'Keep studying the different clefs. You\'ll get better with practice!';
    }
  }
}

class ClefInfo {
  final String name;
  final String description;
  final String imagePath;
  final String notesImagePath;

  ClefInfo({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.notesImagePath,
  });
}

enum QuestionType {
  imageToName,
  imageToDescription,
  nameToImage,
  descriptionToImage,
  nameToDescription,
  descriptionToName,
}

class Question {
  final QuestionType type;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? clefImage;

  Question({
    required this.type,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.clefImage,
  });
}
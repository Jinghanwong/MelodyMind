import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizAccidentalsPage extends StatefulWidget {
  const QuizAccidentalsPage({Key? key}) : super(key: key);

  @override
  _QuizAccidentalsPageState createState() => _QuizAccidentalsPageState();
}

class _QuizAccidentalsPageState extends State<QuizAccidentalsPage> {
  int _score = 0;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  List<int> _userAnswers = List.filled(10, -1);
  List<Question> _questions = [];
  final Random _random = Random();

  // 添加一个标志来跟踪当前问题是否已回答
  bool _currentQuestionAnswered = false;
  // 添加一个变量来存储用户选择的答案索引
  int _selectedAnswerIndex = -1;

  // Create audio player instances
  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _incorrectSoundPlayer = AudioPlayer();

  // Data for our quiz
  final List<AccidentalInfo> _accidentalsInfo = [
    AccidentalInfo(
      name: 'Sharp',
      description: 'Raises a note by a half step',
      imagePath: 'assets/images/symbols/sharp.PNG',
      effect:
          'Instead of the original note, you should play the note that is a half step above (on the right of the piano)',
    ),
    AccidentalInfo(
      name: 'Flat',
      description: 'Lowers a note by a half step',
      imagePath: 'assets/images/symbols/flat.PNG',
      effect:
          'Instead of the original note, you should play the note that is a half step below (on the left of the piano)',
    ),
    AccidentalInfo(
      name: 'Double-sharp',
      description: 'Raises a note by two half steps',
      imagePath: 'assets/images/symbols/double_sharp.PNG',
      effect:
          'Instead of the original note, you should play the note that is two half steps above (on the right of the piano)',
    ),
    AccidentalInfo(
      name: 'Double-flat',
      description: 'Lowers a note by two half steps',
      imagePath: 'assets/images/symbols/double_flat.PNG',
      effect:
          'Instead of the original note, you should play the note that is two half steps below (on the left of the piano)',
    ),
    AccidentalInfo(
      name: 'Natural',
      description: 'Cancels the effect of another accidental',
      imagePath: 'assets/images/symbols/natural.PNG',
      effect:
          'Returns a note to its natural state, canceling any previous accidentals',
    ),
  ];

  // Examples of accidental notes to quiz on
  final List<AccidentalNoteInfo> _accidentalNotes = [
    AccidentalNoteInfo(
      name: 'C♯',
      description: 'C-sharp is a half step above C',
      imagePath: 'assets/images/symbols/c_sharp.PNG',
    ),
    AccidentalNoteInfo(
      name: 'B♭',
      description: 'B-flat is a half step below B',
      imagePath: 'assets/images/symbols/b_flat.PNG',
    ),
    AccidentalNoteInfo(
      name: 'F𝄪',
      description: 'F-double-sharp is two half steps above F',
      imagePath: 'assets/images/symbols/f_double_sharp.PNG',
    ),
    AccidentalNoteInfo(
      name: 'E♭♭',
      description: 'E-double-flat is two half steps below E',
      imagePath: 'assets/images/symbols/e_double_flat.PNG',
    ),
    AccidentalNoteInfo(
      name: 'D♮',
      description: 'D-natural cancels any previously applied accidental on D',
      imagePath: 'assets/images/symbols/d_natural.PNG',
    ),
  ];

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
      QuestionType.noteToAccidental,
      QuestionType.accidentalToNote,
      QuestionType.effectToAccidental,
      QuestionType.accidentalToEffect,
    ];

    for (int i = 0; i < 10; i++) {
      // Select a random question type
      final QuestionType type = types[_random.nextInt(types.length)];

      // For accidental-based questions
      if (type != QuestionType.noteToAccidental &&
          type != QuestionType.accidentalToNote) {
        // Select the correct answer index
        final int correctAccidentalIndex =
            _random.nextInt(_accidentalsInfo.length);

        // Generate wrong options by selecting two different accidental indices
        final List<int> wrongIndices = [];
        while (wrongIndices.length < 2) {
          final int index = _random.nextInt(_accidentalsInfo.length);
          if (index != correctAccidentalIndex &&
              !wrongIndices.contains(index)) {
            wrongIndices.add(index);
          }
        }

        // Create the question based on the selected type
        final Question question = _createAccidentalQuestion(
          type: type,
          correctAccidentalIndex: correctAccidentalIndex,
          wrongIndices: wrongIndices,
        );

        questions.add(question);
      }
      // For note-based questions
      else {
        // Select the correct answer index
        final int correctNoteIndex = _random.nextInt(_accidentalNotes.length);

        // Generate wrong options by selecting two different note indices
        final List<int> wrongIndices = [];
        while (wrongIndices.length < 2) {
          final int index = _random.nextInt(_accidentalNotes.length);
          if (index != correctNoteIndex && !wrongIndices.contains(index)) {
            wrongIndices.add(index);
          }
        }

        // Create the question based on the selected type
        final Question question = _createNoteQuestion(
          type: type,
          correctNoteIndex: correctNoteIndex,
          wrongIndices: wrongIndices,
        );

        questions.add(question);
      }
    }

    setState(() {
      _questions = questions;
    });
  }

  Question _createAccidentalQuestion({
    required QuestionType type,
    required int correctAccidentalIndex,
    required List<int> wrongIndices,
  }) {
    String question;
    List<String> options = [];

    final AccidentalInfo correctAccidental =
        _accidentalsInfo[correctAccidentalIndex];
    final AccidentalInfo wrongAccidental1 = _accidentalsInfo[wrongIndices[0]];
    final AccidentalInfo wrongAccidental2 = _accidentalsInfo[wrongIndices[1]];

    switch (type) {
      case QuestionType.imageToName:
        question = 'What is the name of this accidental?';
        options = [
          correctAccidental.name,
          wrongAccidental1.name,
          wrongAccidental2.name
        ];
        break;

      case QuestionType.imageToDescription:
        question = 'What does this accidental do?';
        options = [
          correctAccidental.description,
          wrongAccidental1.description,
          wrongAccidental2.description
        ];
        break;

      case QuestionType.nameToImage:
        question = 'Which symbol represents the ${correctAccidental.name}?';
        options = [
          correctAccidental.imagePath,
          wrongAccidental1.imagePath,
          wrongAccidental2.imagePath
        ];
        break;

      case QuestionType.descriptionToImage:
        question = 'Which accidental ${correctAccidental.description}?';
        options = [
          correctAccidental.imagePath,
          wrongAccidental1.imagePath,
          wrongAccidental2.imagePath
        ];
        break;

      case QuestionType.nameToDescription:
        question = 'What does the ${correctAccidental.name} do?';
        options = [
          correctAccidental.description,
          wrongAccidental1.description,
          wrongAccidental2.description
        ];
        break;

      case QuestionType.descriptionToName:
        question =
            'What is the name of the accidental that ${correctAccidental.description}?';
        options = [
          correctAccidental.name,
          wrongAccidental1.name,
          wrongAccidental2.name
        ];
        break;

      case QuestionType.effectToAccidental:
        question =
            'Which accidental has this effect: ${correctAccidental.effect}?';
        options = [
          correctAccidental.imagePath,
          wrongAccidental1.imagePath,
          wrongAccidental2.imagePath
        ];
        break;

      case QuestionType.accidentalToEffect:
        question = 'What is the effect of this accidental?';
        options = [
          correctAccidental.effect,
          wrongAccidental1.effect,
          wrongAccidental2.effect
        ];
        break;

      default:
        question = 'What is the name of this accidental?';
        options = [
          correctAccidental.name,
          wrongAccidental1.name,
          wrongAccidental2.name
        ];
    }

    // Shuffle options to randomize the position of the correct answer
    final List<String> shuffledOptions = [...options];
    shuffledOptions.shuffle(_random);

    // Find the index of the correct answer in the shuffled options
    final int correctOptionIndex = shuffledOptions.indexOf(options[0]);

    return Question(
      type: type,
      question: question,
      options: shuffledOptions,
      correctOptionIndex: correctOptionIndex,
      questionImage: (type == QuestionType.imageToName ||
              type == QuestionType.imageToDescription ||
              type == QuestionType.accidentalToEffect)
          ? correctAccidental.imagePath
          : null,
    );
  }

  Question _createNoteQuestion({
  required QuestionType type,
  required int correctNoteIndex,
  required List<int> wrongIndices,
}) {
  String question;
  List<String> options = [];

  final AccidentalNoteInfo correctNote = _accidentalNotes[correctNoteIndex];
  final AccidentalNoteInfo wrongNote1 = _accidentalNotes[wrongIndices[0]];
  final AccidentalNoteInfo wrongNote2 = _accidentalNotes[wrongIndices[1]];

  switch (type) {
    case QuestionType.noteToAccidental:
      question = 'Which accidental is used in ${correctNote.name}?';

      // Determine which accidental is in the note name
      String correctAccidentalPath = '';
      if (correctNote.name.contains('♯')) {
        correctAccidentalPath = _accidentalsInfo[0].imagePath; // Sharp
      } else if (correctNote.name.contains('♭')) {
        correctAccidentalPath = _accidentalsInfo[1].imagePath; // Flat
      } else if (correctNote.name.contains('𝄪')) {
        correctAccidentalPath = _accidentalsInfo[2].imagePath; // Double-sharp
      } else if (correctNote.name.contains('♭♭')) {
        correctAccidentalPath = _accidentalsInfo[3].imagePath; // Double-flat
      } else if (correctNote.name.contains('♮')) {
        correctAccidentalPath = _accidentalsInfo[4].imagePath; // Natural
      }

      // Get two different accidental paths for wrong answers
      List<String> availableWrongPaths = _accidentalsInfo
          .map((info) => info.imagePath)
          .where((path) => path != correctAccidentalPath)
          .toList();
      availableWrongPaths.shuffle(_random);

      options = [
        correctAccidentalPath,
        availableWrongPaths[0],
        availableWrongPaths[1]
      ];
      break;

    case QuestionType.accidentalToNote:
      question =
          'Which note uses the ${_getAccidentalNameFromNote(correctNote.name)}?';
      options = [correctNote.name, wrongNote1.name, wrongNote2.name];
      break;

    default:
      question = 'What is the name of this note?';
      options = [correctNote.name, wrongNote1.name, wrongNote2.name];
  }

  // Shuffle options to randomize the position of the correct answer
  final List<String> shuffledOptions = [...options];
  shuffledOptions.shuffle(_random);

  // Find the index of the correct answer in the shuffled options
  final int correctOptionIndex = shuffledOptions.indexOf(options[0]);

  // 只为默认类型的问题设置图片，noteToAccidental和accidentalToNote都不显示图片
  String? questionImagePath = null;
  if (type != QuestionType.noteToAccidental && type != QuestionType.accidentalToNote) {
    questionImagePath = correctNote.imagePath;
  }

  return Question(
    type: type,
    question: question,
    options: shuffledOptions,
    correctOptionIndex: correctOptionIndex,
    questionImage: questionImagePath,
  );
}

  String _getAccidentalNameFromNote(String noteName) {
    if (noteName.contains('♯')) {
      return 'Sharp';
    } else if (noteName.contains('♭♭')) {
      return 'Double-flat';
    } else if (noteName.contains('♭')) {
      return 'Flat';
    } else if (noteName.contains('𝄪')) {
      return 'Double-sharp';
    } else if (noteName.contains('♮')) {
      return 'Natural';
    }
    return '';
  }

  // 修改回答问题的方法
  void _answerQuestion(int selectedOptionIndex) {
    if (_currentQuestionIndex < _questions.length &&
        !_currentQuestionAnswered) {
      setState(() {
        _userAnswers[_currentQuestionIndex] = selectedOptionIndex;
        _selectedAnswerIndex = selectedOptionIndex;
        _currentQuestionAnswered = true;

        // 检查答案并播放相应声音
        if (selectedOptionIndex ==
            _questions[_currentQuestionIndex].correctOptionIndex) {
          _score++;
          _playCorrectSound();

          // 如果答案正确，添加一个短暂的延迟后自动进入下一题
          Future.delayed(const Duration(milliseconds: 800), () {
            if (_currentQuestionIndex < _questions.length - 1) {
              _moveToNextQuestion();
            } else {
              _completeQuiz();
            }
          });
        } else {
          _playIncorrectSound();
          // 如果答案错误，需要用户点击"下一题"按钮
        }
      });
    }
  }

  // 添加移动到下一题的方法
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
          'quiz_type': 'Accidentals',
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

  // Show exit confirmation dialog
  Future<bool> _showExitConfirmationDialog() async {
    // If quiz is completed, return directly without prompt
    if (_quizCompleted) {
      return true;
    }

    // Show confirmation dialog
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

    // Return dialog result
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
            'Accidentals Quiz',
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
                // Display image if question has an image
                if (currentQuestion.questionImage != null)
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      currentQuestion.questionImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._buildOptions(currentQuestion),
          // 添加显示正确答案和下一题按钮的部分
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
                    border:
                        Border.all(color: const Color(0xFFFF9A9E), width: 2),
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

                // 下一题按钮
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton.icon(
                    onPressed: _moveToNextQuestion,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(_currentQuestionIndex < _questions.length - 1
                        ? 'Next Question'
                        : 'Finish Quiz'),
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

  // 添加显示正确答案的组件
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

      // 确定按钮颜色
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
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
      return 'Perfect! You\'re an accidentals expert!';
    } else if (_score >= 8) {
      return 'Great job! You have a solid understanding of accidentals.';
    } else if (_score >= 6) {
      return 'Good work! Keep practicing to improve your knowledge of accidentals.';
    } else if (_score >= 4) {
      return 'You\'re getting there! A bit more practice will help you master accidentals.';
    } else {
      return 'Keep studying the different accidentals. You\'ll get better with practice!';
    }
  }
}

// Classes to structure our data
class AccidentalInfo {
  final String name;
  final String description;
  final String imagePath;
  final String effect;

  AccidentalInfo({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.effect,
  });
}

class AccidentalNoteInfo {
  final String name;
  final String description;
  final String imagePath;

  AccidentalNoteInfo({
    required this.name,
    required this.description,
    required this.imagePath,
  });
}

enum QuestionType {
  imageToName,
  imageToDescription,
  nameToImage,
  descriptionToImage,
  nameToDescription,
  descriptionToName,
  noteToAccidental,
  accidentalToNote,
  effectToAccidental,
  accidentalToEffect,
}

class Question {
  final QuestionType type;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? questionImage;

  Question({
    required this.type,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.questionImage,
  });
}

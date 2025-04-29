import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizKeySignaturesPage extends StatefulWidget {
  const QuizKeySignaturesPage({Key? key}) : super(key: key);

  @override
  _QuizKeySignaturesPageState createState() => _QuizKeySignaturesPageState();
}

class _QuizKeySignaturesPageState extends State<QuizKeySignaturesPage> {
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

  // 创建音频播放器实例
  final AudioPlayer _correctSoundPlayer = AudioPlayer();
  final AudioPlayer _incorrectSoundPlayer = AudioPlayer();

  // 调号信息数据
  final List<KeySignatureInfo> _keySignatureInfo = [
    KeySignatureInfo(
      key: 'C major',
      sharpsFlats: '0 sharps/flats',
      imagePath: 'assets/images/symbols/key_c_major.png',
      notesInKey: ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
      position: 0,
    ),
    KeySignatureInfo(
      key: 'G major',
      sharpsFlats: '1 sharp (F♯)',
      imagePath: 'assets/images/symbols/key_g_major.png',
      notesInKey: ['G', 'A', 'B', 'C', 'D', 'E', 'F♯'],
      position: 1,
    ),
    KeySignatureInfo(
      key: 'D major',
      sharpsFlats: '2 sharps (F♯, C♯)',
      imagePath: 'assets/images/symbols/key_d_major.png',
      notesInKey: ['D', 'E', 'F♯', 'G', 'A', 'B', 'C♯'],
      position: 2,
    ),
    KeySignatureInfo(
      key: 'A major',
      sharpsFlats: '3 sharps (F♯, C♯, G♯)',
      imagePath: 'assets/images/symbols/key_a_major.png',
      notesInKey: ['A', 'B', 'C♯', 'D', 'E', 'F♯', 'G♯'],
      position: 3,
    ),
    KeySignatureInfo(
      key: 'E major',
      sharpsFlats: '4 sharps (F♯, C♯, G♯, D♯)',
      imagePath: 'assets/images/symbols/key_e_major.png',
      notesInKey: ['E', 'F♯', 'G♯', 'A', 'B', 'C♯', 'D♯'],
      position: 4,
    ),
    KeySignatureInfo(
      key: 'F major',
      sharpsFlats: '1 flat (B♭)',
      imagePath: 'assets/images/symbols/key_f_major.png',
      notesInKey: ['F', 'G', 'A', 'B♭', 'C', 'D', 'E'],
      position: -1,
    ),
    KeySignatureInfo(
      key: 'B♭ major',
      sharpsFlats: '2 flats (B♭, E♭)',
      imagePath: 'assets/images/symbols/key_bb_major.png',
      notesInKey: ['B♭', 'C', 'D', 'E♭', 'F', 'G', 'A'],
      position: -2,
    ),
    KeySignatureInfo(
      key: 'E♭ major',
      sharpsFlats: '3 flats (B♭, E♭, A♭)',
      imagePath: 'assets/images/symbols/key_eb_major.png',
      notesInKey: ['E♭', 'F', 'G', 'A♭', 'B♭', 'C', 'D'],
      position: -3,
    ),
  ];

  // 调号的问题类型
  //final List<String> _sharpOrder = ['F', 'C', 'G', 'D', 'A', 'E', 'B'];
  //final List<String> _flatOrder = ['B', 'E', 'A', 'D', 'G', 'C', 'F'];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  // 播放正确答案声音
  void _playCorrectSound() async {
    await _correctSoundPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  // 播放错误答案声音
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
      QuestionType.keyToAccidentals,
      QuestionType.accidentalsToKey,
      QuestionType.keyToSymbol,
      QuestionType.symbolToKey,
      QuestionType.identifySharpOrder,
      QuestionType.identifyFlatOrder,
      QuestionType.circleOfFifths,
    ];

    for (int i = 0; i < 10; i++) {
      // 选择一个随机问题类型
      final QuestionType type = types[_random.nextInt(types.length)];

      Question question;
      switch (type) {
        case QuestionType.keyToAccidentals:
        case QuestionType.accidentalsToKey:
        case QuestionType.keyToSymbol:
        case QuestionType.symbolToKey:
          // 选择正确答案索引
          final int correctIndex = _random.nextInt(_keySignatureInfo.length);
          // 生成错误选项
          final List<int> wrongIndices = [];
          while (wrongIndices.length < 2) {
            final int index = _random.nextInt(_keySignatureInfo.length);
            if (index != correctIndex && !wrongIndices.contains(index)) {
              wrongIndices.add(index);
            }
          }
          question = _createKeySignatureQuestion(
            type: type,
            correctIndex: correctIndex,
            wrongIndices: wrongIndices,
          );
          break;
        case QuestionType.identifySharpOrder:
          question = _createSharpOrderQuestion();
          break;
        case QuestionType.identifyFlatOrder:
          question = _createFlatOrderQuestion();
          break;
        case QuestionType.circleOfFifths:
          question = _createCircleOfFifthsQuestion();
          break;
      }

      questions.add(question);
    }

    setState(() {
      _questions = questions;
    });
  }

  Question _createKeySignatureQuestion({
    required QuestionType type,
    required int correctIndex,
    required List<int> wrongIndices,
  }) {
    String question;
    List<String> options = [];
    String? imageAsset;

    final KeySignatureInfo correctInfo = _keySignatureInfo[correctIndex];
    final KeySignatureInfo wrongInfo1 = _keySignatureInfo[wrongIndices[0]];
    final KeySignatureInfo wrongInfo2 = _keySignatureInfo[wrongIndices[1]];

    switch (type) {
      case QuestionType.keyToAccidentals:
        question =
            'How many sharps or flats are in the key of ${correctInfo.key}?';
        options = [
          correctInfo.sharpsFlats,
          wrongInfo1.sharpsFlats,
          wrongInfo2.sharpsFlats
        ];
        break;

      case QuestionType.accidentalsToKey:
        question = 'Which major key has ${correctInfo.sharpsFlats}?';
        options = [correctInfo.key, wrongInfo1.key, wrongInfo2.key];
        break;

      case QuestionType.keyToSymbol:
        question = 'Which key signature represents ${correctInfo.key}?';
        options = [
          correctInfo.imagePath,
          wrongInfo1.imagePath,
          wrongInfo2.imagePath
        ];
        break;

      case QuestionType.symbolToKey:
        question = 'What major key does this key signature represent?';
        imageAsset = correctInfo.imagePath;
        options = [correctInfo.key, wrongInfo1.key, wrongInfo2.key];
        break;

      default:
        // 这些情况应该在外部处理
        question = '';
        options = [];
    }

    // 打乱选项以随机化正确答案的位置
    final List<String> shuffledOptions = [...options];
    shuffledOptions.shuffle(_random);

    // 在打乱的选项中找到正确答案的索引
    final int correctOptionIndex = shuffledOptions.indexOf(options[0]);

    return Question(
      type: type,
      question: question,
      options: shuffledOptions,
      correctOptionIndex: correctOptionIndex,
      noteImage: imageAsset,
    );
  }

  Question _createSharpOrderQuestion() {
    final String question =
        'What is the correct order of sharps in key signatures?';

    // 创建一个正确的顺序
    final String correctOrder = 'F-C-G-D-A-E-B';

    // 创建两个错误的顺序
    List<String> wrongOrders = [
      'C-G-D-A-E-B-F', // 错误顺序1
      'B-E-A-D-G-C-F', // 错误顺序2（实际上是降号的顺序）
    ];

    final List<String> options = [correctOrder, ...wrongOrders];

    // 打乱选项
    final List<String> shuffledOptions = [...options];
    shuffledOptions.shuffle(_random);

    // 找到正确答案的索引
    final int correctOptionIndex = shuffledOptions.indexOf(correctOrder);

    return Question(
      type: QuestionType.identifySharpOrder,
      question: question,
      options: shuffledOptions,
      correctOptionIndex: correctOptionIndex,
    );
  }

  Question _createFlatOrderQuestion() {
    final String question =
        'What is the correct order of flats in key signatures?';

    // 创建一个正确的顺序
    final String correctOrder = 'B-E-A-D-G-C-F';

    // 创建两个错误的顺序
    List<String> wrongOrders = [
      'F-C-G-D-A-E-B', // 错误顺序1（实际上是升号的顺序）
      'B-A-D-G-E-C-F', // 错误顺序2
    ];

    final List<String> options = [correctOrder, ...wrongOrders];

    // 打乱选项
    final List<String> shuffledOptions = [...options];
    shuffledOptions.shuffle(_random);

    // 找到正确答案的索引
    final int correctOptionIndex = shuffledOptions.indexOf(correctOrder);

    return Question(
      type: QuestionType.identifyFlatOrder,
      question: question,
      options: shuffledOptions,
      correctOptionIndex: correctOptionIndex,
    );
  }

  Question _createCircleOfFifthsQuestion() {
    // 在圆周循环中移动一个五度时，会发生什么变化？
    final List<String> questions = [
      'What happens when you move one position clockwise around the circle of fifths?',
      'What happens when you move one position counterclockwise around the circle of fifths?',
      'Which direction on the circle of fifths adds more sharps to the key signature?',
    ];

    final String question = questions[_random.nextInt(questions.length)];

    List<String> options = [];
    int correctOptionIndex;

    switch (question) {
      case 'What happens when you move one position clockwise around the circle of fifths?':
        options = [
          'You add one sharp (or remove one flat)',
          'You add one flat (or remove one sharp)',
          'The key signature stays the same',
        ];
        correctOptionIndex = 0;
        break;

      case 'What happens when you move one position counterclockwise around the circle of fifths?':
        options = [
          'You add one flat (or remove one sharp)',
          'You add one sharp (or remove one flat)',
          'You get a minor key',
        ];
        correctOptionIndex = 0;
        break;

      case 'Which direction on the circle of fifths adds more sharps to the key signature?':
        options = [
          'Clockwise',
          'Counterclockwise',
          'Both directions add sharps',
        ];
        correctOptionIndex = 0;
        break;

      default:
        options = [
          'You add one sharp (or remove one flat)',
          'You add one flat (or remove one sharp)',
          'The key signature stays the same',
        ];
        correctOptionIndex = 0;
    }

    // 对于圆周问题，我们可能不需要打乱选项顺序，因为正确答案的位置已经在创建时确定
    return Question(
      type: QuestionType.circleOfFifths,
      question: question,
      options: options,
      correctOptionIndex: correctOptionIndex,
    );
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
          'quiz_type': 'Key Signatures',
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

  // 显示退出确认对话框
  Future<bool> _showExitConfirmationDialog() async {
    // 如果测验已完成，直接返回，不需要提示
    if (_quizCompleted) {
      return true;
    }

    // 显示确认对话框
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

    // 返回对话框结果，如果用户点击Yes则返回true，否则返回false
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
            'Key Signatures Quiz',
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
                // 如果问题包含图像，则显示图像
                if (currentQuestion.noteImage != null)
                  Container(
                    height: 80,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      currentQuestion.noteImage!,
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
            onPressed:
                _currentQuestionAnswered ? null : () => _answerQuestion(i),
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
      return 'Perfect! You\'re a music notation expert!';
    } else if (_score >= 8) {
      return 'Great job! You have a solid understanding of music notation.';
    } else if (_score >= 6) {
      return 'Good work! Keep practicing to improve your music notation knowledge.';
    } else if (_score >= 4) {
      return 'You\'re getting there! A bit more practice will help.';
    } else {
      return 'Keep studying the time values and names. You\'ll get better with practice!';
    }
  }
}

// Classes to structure our data
class KeySignatureInfo {
  final String key;
  final String sharpsFlats;
  final String imagePath;
  final List<String> notesInKey; // Changed from String to List<String>
  final int position; // Changed from String to int

  KeySignatureInfo({
    required this.key,
    required this.sharpsFlats,
    required this.imagePath,
    required this.notesInKey,
    required this.position,
  });
}

enum QuestionType {
  keyToAccidentals,
  accidentalsToKey,
  keyToSymbol,
  symbolToKey,
  identifyFlatOrder,
  identifySharpOrder,
  circleOfFifths,
}

class Question {
  final QuestionType type;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? noteImage; // Changed from signatureImage to noteImage

  Question({
    required this.type,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.noteImage, // Changed parameter name to match usage in code
  });
}

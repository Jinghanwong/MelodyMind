import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _musicTheoryResults = [];
  List<Map<String, dynamic>> _earTrainingResults =
      []; // Added list for ear training
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadQuizResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadQuizResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseDatabase.instance
            .ref()
            .child('quiz_results')
            .child(user.uid)
            .get();

        if (snapshot.exists && snapshot.value != null) {
          List<Map<String, dynamic>> theoryResults = [];
          List<Map<String, dynamic>> earResults = [];

          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;

          values.forEach((quizId, quizData) {
            if (quizData is Map) {
              Map<String, dynamic> result = {};
              quizData.forEach((key, value) {
                result[key.toString()] = value;
              });

              result['id'] = quizId.toString();

              // Check if quiz is ear training (difficulty levels: Easy, Average, Advanced)
              if (['Easy', 'Intermediate', 'Advanced']
                  .contains(result['quiz_type'])) {
                earResults.add(result);
              } else {
                // All other quiz types go to theory results
                theoryResults.add(result);
              }
            }
          });

          // Sort by most recent first
          theoryResults.sort(
              (a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
          earResults.sort(
              (a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));

          setState(() {
            _musicTheoryResults = theoryResults;
            _earTrainingResults = earResults;
            _isLoading = false;
          });
        } else {
          setState(() {
            _musicTheoryResults = [];
            _earTrainingResults = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading quiz results: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          'Quiz Results',
          style: TextStyle(
            color: Color(0xFF753027),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF753027),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF753027),
          tabs: const [
            Tab(text: 'Music Theory'),
            Tab(text: 'Ear Training'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Music Theory Tab
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _musicTheoryResults.isEmpty
                  ? Center(
                      child: Text(
                        'No quiz results yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: _musicTheoryResults.map((result) {
                          return Column(
                            children: [
                              _buildResultCard(
                                title: result['quiz_type'] ?? 'Unknown Quiz',
                                date: result['date'] ?? 'N/A',
                                percentage: '${result['percentage']}%',
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
          // Ear Training Tab
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _earTrainingResults.isEmpty
                  ? Center(
                      child: Text(
                        'No ear training results yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: _earTrainingResults.map((result) {
                          return Column(
                            children: [
                              _buildResultCard(
                                title: result['quiz_type'] ?? 'Unknown Quiz',
                                date: result['date'] ?? 'N/A',
                                percentage: '${result['percentage']}%',
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String date,
    required String percentage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5B7B7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/questions.dart';
import 'ScoresPage.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _questions = [
    Question(
      questionText: 'What is Flutter?',
      options: ['Framework', 'Programming Language', 'IDE', 'None'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which language is used by Flutter?',
      options: ['Dart', 'Java', 'Python', 'C++'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'What is the use of the `async` keyword in Dart?',
      options: ['To handle asynchronous operations', 'To define a class', 'To create a new thread', 'None of the above'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which widget is used to create a scrollable list in Flutter?',
      options: ['ListView', 'Column', 'Row', 'Stack'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'What is the purpose of the `pubspec.yaml` file in a Flutter project?',
      options: ['To define project dependencies', 'To define routes', 'To configure Firebase', 'To create assets'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'How do you declare a variable in Dart?',
      options: ['var myVariable', 'variable myVariable', 'let myVariable', 'const myVariable'],
      correctAnswerIndex: 0,
    ),
    // Add more questions here
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;

  void _submitAnswer(int selectedOptionIndex) {
    if (selectedOptionIndex == _questions[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Navigate to ScorePage and pass the score
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(score: _score, totalQuestions: _questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion.questionText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            ...currentQuestion.options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(option),
                    onTap: () => _submitAnswer(idx),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

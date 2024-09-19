import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this package to use SVG images
import '../../services/student_service.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ScorePage({required this.score, required this.totalQuestions});

  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    // Save the score in student data
    _saveScore();

    // Determine the comment based on the score
    String comment;
    if (score >= totalQuestions * 0.8) {
      comment = 'Wow, you did a great job!';
    } else if (score >= totalQuestions * 0.5) {
      comment = 'Good effort! Keep practicing!';
    } else {
      comment = 'Need to study harder. You got this!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Score'),
        backgroundColor: Color(0xFFFEBE10), // Match AppBar color with the theme
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card to display the score and comment
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                    children: [
                      // Trophy Icon and Score
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/trophy.svg', // Ensure this SVG exists in your assets
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Your Score: $score/$totalQuestions',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Comment based on score
                      Text(
                        comment,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFEBE10),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Back Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveScore() async {
    try {
      await _studentService.saveQuizScore(
        studentId: 'O1FsNm0PkQU5i1pQrj2q9yUOknA2', // Replace with actual student ID
        score: score,
      );
      print('Score saved successfully.');
    } catch (e) {
      print('Error saving score: $e');
    }
  }
}

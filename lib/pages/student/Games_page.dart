import 'package:flutter/material.dart';
import 'QuizPage.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Games'),
        backgroundColor: Color(0xFFFEBE10), // Customized AppBar Color
      ),
      body: Container(
        color: Colors.white, // White background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
        "Play Games and Boost Your Score:",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text in black color
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFFEBE10),
                  child: Icon(Icons.quiz, color: Colors.white), // Icon for Quiz Game
                ),
                title: Text(
                  'Quiz Game',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Test your knowledge!'),
                trailing: Icon(Icons.arrow_forward, color: Color(0xFFFEBE10)),
                onTap: () {
                  // Navigate to the QuizPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            // Add more games below
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFFEBE10),
                  child: Icon(Icons.hourglass_empty, color: Colors.white), // Placeholder icon for future games
                ),
                title: Text(
                  'Coming Soon!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('More games coming soon...'),
                trailing: Icon(Icons.arrow_forward, color: Color(0xFFFEBE10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

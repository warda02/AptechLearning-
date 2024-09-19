import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class ClassDetailPage extends StatelessWidget {
  final String title;
  final String dateTime;
  final String instructor;
  final String meetingLink;
  final String meetingPassword;

  ClassDetailPage({
    required this.title,
    required this.dateTime,
    required this.instructor,
    required this.meetingLink,
    required this.meetingPassword, required String faculty, required String date, required String time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Information
            Text(
              'Class Title: $title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Date & Time: $dateTime'),
            SizedBox(height: 16),
            Text('Instructor: $instructor'),
            SizedBox(height: 16),

            // Join Button
            ElevatedButton(
              onPressed: () {
                _joinClassOnline(context);
              },
              child: Text('Join Class Online'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch the meeting link
  void _joinClassOnline(BuildContext context) async {
    if (await canLaunch(meetingLink)) {
      await launch(meetingLink);
    } else {
      _showErrorDialog(context, 'Could not launch $meetingLink');
    }
  }

  // Function to show an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

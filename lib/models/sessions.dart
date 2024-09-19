import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String id;
  final String title;
  final String time;
  final String date;
  final String faculty;
  final String zoomLink; // Add this line

  Session({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.faculty,
    required this.zoomLink, // Add this line
  });

  factory Session.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Session(
      id: snapshot.id,
      title: data['title'] ?? 'No Title',
      time: data['time'] ?? 'No Time',
      date: data['date'] ?? 'No Date',
      faculty: data['faculty'] ?? 'No Faculty',
      zoomLink: data['zoomLink'] ?? '', // Add this line
    );
  }
}

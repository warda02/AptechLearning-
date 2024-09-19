import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  final String id;
  final String title;
  final String date; // Using String to represent the date
  final String examType; // Updated field name to 'examType'
  final String imageUrl;
  final String time;

  Exam({
    required this.id,
    required this.title,
    required this.date,
    required this.examType,
    required this.imageUrl,
    required this.time,
  });

  factory Exam.fromMap(Map<String, dynamic> data) {
    return Exam(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      date: data['date'] ?? '', // Directly use the string
      examType: data['examType'] ?? '', // Updated key name
      imageUrl: data['imageUrl'] ?? '', // Added field for image URL
      time: data['time'] ?? '', // Added field for time
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date, // Directly store the string
      'examType': examType, // Updated key name
      'imageUrl': imageUrl, // Added field for image URL
      'time': time, // Added field for time
    };
  }
}

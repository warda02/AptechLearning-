import 'package:cloud_firestore/cloud_firestore.dart';

class Workshops {
  final String title;
  final String description;
  final String faculty;
  final String date; // Ensure this is a string in the model
  final String imageUrl;

  Workshops({
    required this.title,
    required this.description,
    required this.faculty,
    required this.date,
    required this.imageUrl,
  });

  factory Workshops.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Workshops(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      faculty: data['faculty'] ?? '',
      date: data['date'] ?? '', // Assuming 'date' is stored as a string
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class shortCourses {
  final String id;
  final String courseName;
  final String description;
  final String duration;
  final String fees;
  final String imageUrl;
  final List<String> days;
  final List<String> timeSlots;

  shortCourses({
    required this.id,
    required this.courseName,
    required this.description,
    required this.duration,
    required this.fees,
    required this.imageUrl,
    required this.days,
    required this.timeSlots,
  });

  factory shortCourses.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return shortCourses(
      id: snapshot.id,
      courseName: data['courseName'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      duration: data['duration'] ?? 'No Duration',
      fees: data['fees'] ?? 'No Fees',
      imageUrl: data['imageUrl'] ?? '',
      days: List<String>.from(data['days'] ?? []),
      timeSlots: List<String>.from(data['timeSlots'] ?? []),
    );
  }
}

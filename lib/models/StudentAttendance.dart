import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendance {
  final DateTime date;
  final bool isPresent;

  StudentAttendance({
    required this.date,
    required this.isPresent,
  });

  factory StudentAttendance.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StudentAttendance(
      date: (data['date'] as Timestamp).toDate(),
      isPresent: data['isPresent'] ?? false,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  final String id;
  final String title;
  final String description;
  final Timestamp dueDate;
  final String status;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  // Factory constructor to create an Assignment instance from Firestore document
  factory Assignment.fromDocument(DocumentSnapshot doc) {
    return Assignment(
      id: doc.id,  // Using Firestore document ID as the assignment ID
      title: doc['title'] ?? '', // Fallback to empty string if null
      description: doc['description'] ?? '', // Fallback to empty string if null
      dueDate: doc['dueDate'] ?? Timestamp.now(), // Fallback to current time if null
      status: doc['status'] ?? 'Pending', // Fallback to 'Pending' if null
    );
  }

  // Convert Assignment object to a map to upload to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
    };
  }
}

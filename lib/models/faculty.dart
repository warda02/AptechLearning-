import 'package:cloud_firestore/cloud_firestore.dart';

class Faculty {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String position;
  final String imageUrl;
  final List<String> managedStudents;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.position,
    required this.imageUrl,
    required this.managedStudents,
  });

  // Factory method to create a Faculty instance from Firestore document
  factory Faculty.fromDocument(DocumentSnapshot doc) {
    return Faculty(
      id: doc.id,
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      role: doc['role'] ?? '',
      position: doc['position'] ?? '',
      imageUrl: doc['imageUrl'] ?? 'assets/images/default_image.png',
      managedStudents: List<String>.from(doc['managedStudents'] ?? []), // Convert list of managed students
    );
  }

  // Optional: Convert Faculty object to map (useful for saving data to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'position': position,
      'imageUrl': imageUrl,
      'managedStudents': managedStudents,
    };
  }
}

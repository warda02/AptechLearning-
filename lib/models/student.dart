import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String address;
  final Timestamp enrollmentDate;
  final String imageUrl; // Add this field

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    required this.enrollmentDate,
    required this.imageUrl, // Initialize this field
  });

  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student(
      id: doc.id,
      name: doc['name'] ?? '',
      // Default to empty string if field is missing
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      role: doc['role'] ?? '',
      address: doc['address'] ?? '',
      enrollmentDate: doc['enrollmentDate'] ??
          Timestamp.fromDate(DateTime.now()),
      // Default to current time if missing
      imageUrl: doc['imageUrl'] ??
          'assets/images/default_image.png', // Default image URL if missing
    );
  }

}
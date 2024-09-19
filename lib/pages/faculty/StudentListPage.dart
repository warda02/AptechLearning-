import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aptech_clifton/models/student.dart'; // Import your Student model

class StudentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<List<Student>>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => Student.fromDocument(doc))
            .toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found.'));
          }

          final students = snapshot.data!;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(student.imageUrl),
                ),
                title: Text(student.name),
                subtitle: Text(student.email),
                onTap: () {
                  // Handle item tap, e.g., navigate to student details
                },
              );
            },
          );
        },
      ),
    );
  }
}

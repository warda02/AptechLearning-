import 'package:flutter/material.dart';
import 'faculty_services/StudentManagementService.dart';

class StudentDetailsScreen extends StatelessWidget {
  final String studentId;
  final StudentManagementService studentManagementService = StudentManagementService();

  StudentDetailsScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: studentManagementService.getAssignments(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No assignments found.'));
          }

          List<Map<String, dynamic>> assignments = snapshot.data!;

          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              var assignment = assignments[index];
              return ListTile(
                title: Text(assignment['title']),
                subtitle: Text('Due: ${assignment['dueDate']}'),
                // Additional code to add, update, or delete assignments
              );
            },
          );
        },
      ),
    );
  }
}

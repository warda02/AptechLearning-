import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'faculty_services/FacultyService.dart'; // Import your Firebase service class

class ManageAssignmentsPage extends StatefulWidget {
  @override
  _ManageAssignmentsPageState createState() => _ManageAssignmentsPageState();
}

class _ManageAssignmentsPageState extends State<ManageAssignmentsPage> {
  final FacultyService _facultyService = FacultyService();
  final String studentId = 'O1FsNm0PkQU5i1pQrj2q9yUOknA2'; // Replace with actual student ID
  late Future<List<Map<String, dynamic>>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _assignmentsFuture = _facultyService.getStudentSubcollectionData(studentId, 'assignments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Assignments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddAssignmentDialog(context);
              },
              child: Text('Add Assignment'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Button ka text color white
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _assignmentsFuture,
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
                    Map<String, dynamic> assignment = assignments[index];
                    String assignmentId = assignment['id'] ?? ''; // Safe null check with default empty string
                    String title = assignment['title'] ?? 'No Title'; // Safe null check with default title
                    String description = assignment['description'] ?? 'No Description'; // Safe null check with default description

                    return Card(
                      color: Colors.white, // Card ka background color white
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(description),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showEditAssignmentDialog(context, assignmentId, title, description);
                                  },
                                  child: Text('Edit'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.orange, // Button ka text color white
                                  ),
                                ),
                                SizedBox(width: 8), // Thoda gap dene ke liye
                                ElevatedButton(
                                  onPressed: () {
                                    _facultyService.deleteStudentSubcollectionData(studentId, 'assignments', assignmentId);
                                    setState(() {
                                      _assignmentsFuture = _facultyService.getStudentSubcollectionData(studentId, 'assignments');
                                    });
                                  },
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.orange, // Button ka text color white
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAssignmentDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Assignment'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    title = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    description = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _facultyService.addStudentSubcollectionData(
                    studentId,
                    'assignments',
                    {
                      'title': title,
                      'description': description,
                      'created_at': FieldValue.serverTimestamp(),
                    },
                  );
                  setState(() {
                    _assignmentsFuture = _facultyService.getStudentSubcollectionData(studentId, 'assignments');
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Button ka text color white
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditAssignmentDialog(BuildContext context, String assignmentId, String currentTitle, String currentDescription) {
    final _formKey = GlobalKey<FormState>();
    String title = currentTitle;
    String description = currentDescription;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Assignment'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: currentTitle,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    title = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: currentDescription,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    description = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _facultyService.updateStudentSubcollectionData(
                    studentId,
                    'assignments',
                    assignmentId,
                    {
                      'title': title,
                      'description': description,
                      'updated_at': FieldValue.serverTimestamp(),
                    },
                  );
                  setState(() {
                    _assignmentsFuture = _facultyService.getStudentSubcollectionData(studentId, 'assignments');
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Button ka text color white
              ),
            ),
          ],
        );
      },
    );
  }
}

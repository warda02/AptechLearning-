import 'package:flutter/material.dart';
import '../../models/Exams.dart';
import 'faculty_services/FacultyService.dart'; // Import the Exam model

class ManageExamsPage extends StatefulWidget {
  @override
  _ManageExamsPageState createState() => _ManageExamsPageState();
}

class _ManageExamsPageState extends State<ManageExamsPage> {
  final FacultyService _facultyService = FacultyService();
  late Future<List<Exam>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _examsFuture = _facultyService.getAllExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Exams'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddExamDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set button color to orange
              ),
              child: Text('Add Exam'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Exam>>(
              future: _examsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No exams found.'));
                }

                List<Exam> exams = snapshot.data!;

                return ListView.builder(
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.white, // Set card background color to white
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: exam.imageUrl.isNotEmpty
                                    ? Image.network(exam.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                    : Icon(Icons.image, size: 50),
                                title: Text(exam.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date: ${exam.date}'),
                                    Text('Type: ${exam.examType}'),
                                    Text('Time: ${exam.time}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _facultyService.deleteExam(exam.id);
                                    setState(() {
                                      _examsFuture = _facultyService.getAllExams();
                                    });
                                  },
                                ),
                              ),
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

  void _showAddExamDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String date = '';
    String examType = '';
    String imageUrl = '';
    String time = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Exam'),
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
                  decoration: InputDecoration(labelText: 'Date'),
                  onSaved: (value) {
                    date = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Exam Type'),
                  onSaved: (value) {
                    examType = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an exam type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) {
                    imageUrl = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Time'),
                  onSaved: (value) {
                    time = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
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
                  _facultyService.addExam(
                    {
                      'title': title,
                      'date': date,
                      'examType': examType,
                      'imageUrl': imageUrl,
                      'time': time,
                    },
                  );
                  setState(() {
                    _examsFuture = _facultyService.getAllExams();
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
}

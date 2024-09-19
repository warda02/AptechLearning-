import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ManagePerformanceRecordPage extends StatefulWidget {
  @override
  _ManagePerformanceRecordPageState createState() => _ManagePerformanceRecordPageState();
}

class _ManagePerformanceRecordPageState extends State<ManagePerformanceRecordPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String studentId = 'O1FsNm0PkQU5i1pQrj2q9yUOknA2';
  late Future<List<Map<String, dynamic>>> _performanceRecordFuture;
  File? _selectedImage;
  String? _recordIdToEdit;

  @override
  void initState() {
    super.initState();
    _performanceRecordFuture = _getStudentPerformanceRecords(studentId, 'performanceRecords');
  }

  Future<List<Map<String, dynamic>>> _getStudentPerformanceRecords(String studentId, String collectionName) async {
    try {
      final snapshot = await _firestore.collection('students').doc(studentId).collection(collectionName).get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<void> _addOrUpdatePerformanceRecord({
    required String courseName,
    required String examType,
    required int marksObtained,
    required String moduleName,
    required int totalMarks,
    required double weightage,
    required double gpa,
    required int attendancePercentage,
    required String classParticipation,
    required String punctuality,
    required String classBehavior,
    required String teacherFeedback,
    required String performanceSummary,
    String imageUrl = '',
  }) async {
    try {
      if (_recordIdToEdit != null) {
        // Update existing record
        await _firestore.collection('students').doc(studentId).collection('performanceRecords').doc(_recordIdToEdit).update({
          'courseName': courseName,
          'examType': examType,
          'marksObtained': marksObtained,
          'moduleName': moduleName,
          'totalMarks': totalMarks,
          'weightage': weightage,
          'gpa': gpa,
          'attendancePercentage': attendancePercentage,
          'classParticipation': classParticipation,
          'punctuality': punctuality,
          'classBehavior': classBehavior,
          'teacherFeedback': teacherFeedback,
          'performanceSummary': performanceSummary,
          'imageUrl': imageUrl,
          'updated_at': FieldValue.serverTimestamp(),
        });
        print("Performance Record updated successfully");
      } else {
        // Add new record
        await _firestore.collection('students').doc(studentId).collection('performanceRecords').add({
          'courseName': courseName,
          'examType': examType,
          'marksObtained': marksObtained,
          'moduleName': moduleName,
          'totalMarks': totalMarks,
          'weightage': weightage,
          'gpa': gpa,
          'attendancePercentage': attendancePercentage,
          'classParticipation': classParticipation,
          'punctuality': punctuality,
          'classBehavior': classBehavior,
          'teacherFeedback': teacherFeedback,
          'performanceSummary': performanceSummary,
          'imageUrl': imageUrl,
          'created_at': FieldValue.serverTimestamp(),
        });
        print("Performance Record added successfully");
      }
      setState(() {
        _performanceRecordFuture = _getStudentPerformanceRecords(studentId, 'performanceRecords');
      });
    } catch (e) {
      print("Error adding/updating performance record: $e");
    }
  }

  Future<void> _deletePerformanceRecord(String recordId) async {
    try {
      await _firestore.collection('students').doc(studentId).collection('performanceRecords').doc(recordId).delete();
      print("Performance Record deleted successfully");
      setState(() {
        _performanceRecordFuture = _getStudentPerformanceRecords(studentId, 'performanceRecords');
      });
    } catch (e) {
      print("Error deleting performance record: $e");
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().toIso8601String();
      final ref = _storage.ref().child('performanceRecords/$fileName');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  void _showPerformanceRecordDialog({Map<String, dynamic>? record}) {
    final _formKey = GlobalKey<FormState>();
    String courseName = record?['courseName'] ?? '';
    String examType = record?['examType'] ?? '';
    int marksObtained = record?['marksObtained'] ?? 0;
    String moduleName = record?['moduleName'] ?? '';
    int totalMarks = record?['totalMarks'] ?? 0;
    double weightage = record?['weightage'] ?? 0.0;
    double gpa = record?['gpa'] ?? 0.0;
    int attendancePercentage = record?['attendancePercentage'] ?? 0;
    String classParticipation = record?['classParticipation'] ?? '';
    String punctuality = record?['punctuality'] ?? '';
    String classBehavior = record?['classBehavior'] ?? '';
    String teacherFeedback = record?['teacherFeedback'] ?? '';
    String performanceSummary = record?['performanceSummary'] ?? '';
    String imageUrl = record?['imageUrl'] ?? '';

    _recordIdToEdit = record?['id'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_recordIdToEdit == null ? 'Add Performance Record' : 'Edit Performance Record'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: courseName,
                    decoration: InputDecoration(labelText: 'Course Name'),
                    onSaved: (value) {
                      courseName = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter course name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: examType,
                    decoration: InputDecoration(labelText: 'Exam Type'),
                    onSaved: (value) {
                      examType = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter exam type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: marksObtained.toString(),
                    decoration: InputDecoration(labelText: 'Marks Obtained'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      marksObtained = int.tryParse(value ?? '') ?? 0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter marks obtained';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: moduleName,
                    decoration: InputDecoration(labelText: 'Module Name'),
                    onSaved: (value) {
                      moduleName = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: totalMarks.toString(),
                    decoration: InputDecoration(labelText: 'Total Marks'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      totalMarks = int.tryParse(value ?? '') ?? 0;
                    },
                  ),
                  TextFormField(
                    initialValue: weightage.toString(),
                    decoration: InputDecoration(labelText: 'Weightage'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      weightage = double.tryParse(value ?? '') ?? 0.0;
                    },
                  ),
                  TextFormField(
                    initialValue: gpa.toString(),
                    decoration: InputDecoration(labelText: 'GPA'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      gpa = double.tryParse(value ?? '') ?? 0.0;
                    },
                  ),
                  TextFormField(
                    initialValue: attendancePercentage.toString(),
                    decoration: InputDecoration(labelText: 'Attendance Percentage'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      attendancePercentage = int.tryParse(value ?? '') ?? 0;
                    },
                  ),
                  TextFormField(
                    initialValue: classParticipation,
                    decoration: InputDecoration(labelText: 'Class Participation'),
                    onSaved: (value) {
                      classParticipation = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: punctuality,
                    decoration: InputDecoration(labelText: 'Punctuality'),
                    onSaved: (value) {
                      punctuality = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: classBehavior,
                    decoration: InputDecoration(labelText: 'Class Behavior'),
                    onSaved: (value) {
                      classBehavior = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: teacherFeedback,
                    decoration: InputDecoration(labelText: 'Teacher Feedback'),
                    onSaved: (value) {
                      teacherFeedback = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: performanceSummary,
                    decoration: InputDecoration(labelText: 'Performance Summary'),
                    onSaved: (value) {
                      performanceSummary = value ?? '';
                    },
                  ),
                  SizedBox(height: 20),
                  imageUrl.isNotEmpty ? Image.network(imageUrl) : Container(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_selectedImage != null) {
                            final uploadedImageUrl = await _uploadImage(_selectedImage!);
                            await _addOrUpdatePerformanceRecord(
                              courseName: courseName,
                              examType: examType,
                              marksObtained: marksObtained,
                              moduleName: moduleName,
                              totalMarks: totalMarks,
                              weightage: weightage,
                              gpa: gpa,
                              attendancePercentage: attendancePercentage,
                              classParticipation: classParticipation,
                              punctuality: punctuality,
                              classBehavior: classBehavior,
                              teacherFeedback: teacherFeedback,
                              performanceSummary: performanceSummary,
                              imageUrl: uploadedImageUrl,
                            );
                          } else {
                            await _addOrUpdatePerformanceRecord(
                              courseName: courseName,
                              examType: examType,
                              marksObtained: marksObtained,
                              moduleName: moduleName,
                              totalMarks: totalMarks,
                              weightage: weightage,
                              gpa: gpa,
                              attendancePercentage: attendancePercentage,
                              classParticipation: classParticipation,
                              punctuality: punctuality,
                              classBehavior: classBehavior,
                              teacherFeedback: teacherFeedback,
                              performanceSummary: performanceSummary,
                              imageUrl: imageUrl,
                            );
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(_recordIdToEdit == null ? 'Add Record' : 'Update Record'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Performance Records'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showPerformanceRecordDialog();
              },
              child: Text('Add Student Performance'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _performanceRecordFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No records found'));
                  }

                  final records = snapshot.data!;

                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text(record['courseName'] ?? 'No Title'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Exam Type: ${record['examType'] ?? 'N/A'}'),
                              Text('Marks Obtained: ${record['marksObtained'] ?? 0}'),
                              Text('Module Name: ${record['moduleName'] ?? 'N/A'}'),
                              Text('Total Marks: ${record['totalMarks'] ?? 0}'),
                              Text('Weightage: ${record['weightage'] ?? 0.0}'),
                              Text('GPA: ${record['gpa'] ?? 0.0}'),
                              Text('Attendance Percentage: ${record['attendancePercentage'] ?? 0}'),
                              Text('Class Participation: ${record['classParticipation'] ?? 'N/A'}'),
                              Text('Punctuality: ${record['punctuality'] ?? 'N/A'}'),
                              Text('Class Behavior: ${record['classBehavior'] ?? 'N/A'}'),
                              Text('Teacher Feedback: ${record['teacherFeedback'] ?? 'N/A'}'),
                              Text('Performance Summary: ${record['performanceSummary'] ?? 'N/A'}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deletePerformanceRecord(record['id']);
                            },
                          ),
                          onTap: () {
                            _showPerformanceRecordDialog(record: record);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

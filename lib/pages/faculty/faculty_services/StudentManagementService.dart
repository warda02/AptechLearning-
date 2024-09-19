import 'package:cloud_firestore/cloud_firestore.dart';

class StudentManagementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize Subcollections for a Student
  Future<void> initializeStudentData(String studentId) async {
    if (studentId.isEmpty) {
      throw ArgumentError('Student ID cannot be empty');
    }

    try {
      await _db.collection('students').doc(studentId).collection('assignments').add({
        'title': 'Sample Assignment',
        'dueDate': DateTime.now(),
        'description': 'This is a sample assignment.',
      });

      await _db.collection('students').doc(studentId).collection('attendance').add({
        'date': DateTime.now(),
        'status': 'Present',
      });

      await _db.collection('students').doc(studentId).collection('certificate').add({
        'title': 'Sample Certificate',
        'dateIssued': DateTime.now(),
      });

      await _db.collection('students').doc(studentId).collection('exams').add({
        'subject': 'Sample Exam',
        'date': DateTime.now(),
        'score': 90,
      });

      await _db.collection('students').doc(studentId).collection('feesStatus').add({
        'dueDate': DateTime.now(),
        'status': 'Paid',
        'amount': 5000,
      });

      await _db.collection('students').doc(studentId).collection('performanceRecords').add({
        'subject': 'Sample Subject',
        'performance': 'Good',
      });

      await _db.collection('students').doc(studentId).collection('upcomingWorkshops').add({
        'title': 'Sample Workshop',
        'date': DateTime.now(),
        'location': 'Campus A',
      });

      print('Student data initialized successfully.');
    } catch (e) {
      print('Error initializing student data: $e');
    }
  }

  // Fetch the list of students managed by the faculty
  Stream<List<Map<String, dynamic>>> getManagedStudents() {
    return _db.collection('students').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Create or Update Assignment
  Future<void> createOrUpdateAssignment(String studentId, String assignmentId, Map<String, dynamic> assignmentData) async {
    if (studentId.isEmpty || assignmentId.isEmpty) {
      throw ArgumentError('Student ID and Assignment ID cannot be empty');
    }

    try {
      await _db.collection('students').doc(studentId).collection('assignments').doc(assignmentId).set(assignmentData);
      print('Assignment added/updated successfully.');
    } catch (e) {
      print('Error creating/updating assignment: $e');
    }
  }

  // Add Assignment
  Future<void> addAssignment(String studentId, Map<String, dynamic> assignmentData) async {
    if (studentId.isEmpty) {
      throw ArgumentError('Student ID cannot be empty');
    }

    try {
      await _db.collection('students').doc(studentId).collection('assignments').add(assignmentData);
    } catch (e) {
      print('Error adding assignment: $e');
      rethrow;
    }
  }

  // Fetch Assignments
  Stream<List<Map<String, dynamic>>> getAssignments(String studentId) {
    if (studentId.isEmpty) {
      throw ArgumentError('Student ID cannot be empty');
    }

    return _db
        .collection('students')
        .doc(studentId)
        .collection('assignments')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // Delete Assignment
  Future<void> deleteAssignment(String studentId, String assignmentId) async {
    if (studentId.isEmpty || assignmentId.isEmpty) {
      throw ArgumentError('Student ID and Assignment ID cannot be empty');
    }

    try {
      await _db.collection('students').doc(studentId).collection('assignments').doc(assignmentId).delete();
      print('Assignment deleted successfully.');
    } catch (e) {
      print('Error deleting assignment: $e');
    }
  }

// Similar error handling for other CRUD operations (Attendance, Certificate, Exam, FeesStatus, PerformanceRecords, Workshops)
// ...

}

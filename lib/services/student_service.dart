import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/Certificates.dart';
import '../models/FeesStatus.dart';
import '../models/course.dart';
import '../models/sessions.dart';
import '../models/student.dart';
import '../models/student_performance.dart';
import '../models/workshop.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Student> fetchStudent(String studentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection('students').doc(studentId).get();
      if (!doc.exists) {
        throw Exception('Student document does not exist');
      }
      return Student.fromDocument(doc);
    } catch (e) {
      print('Error fetching student data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCollectionData(
      String studentId, String collectionName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('students')
          .doc(studentId)
          .collection(collectionName)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching $collectionName data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPerformanceData(String studentId) async {
    return _fetchCollectionData(studentId, 'performanceRecords');
  }

  Future<Map<String, Map<String, dynamic>>> fetchAttendance(String studentId) async {
    try {
      final attendanceCollection = _firestore
          .collection('students')
          .doc(studentId)
          .collection('attendance');

      final snapshot = await attendanceCollection.get();

      Map<String, Map<String, dynamic>> summary = {};
      for (var doc in snapshot.docs) {
        final data = doc.data()!;
        final semester = data['semester'] as String;
        final totalSessions = int.parse(data['totalSessions'] as String);
        final totalSessionsAttended = int.parse(data['Total Sessions Attended'] as String);
        final attendance = double.parse(data['Attendance'] as String);

        summary[semester] = {
          'Total Sessions': totalSessions,
          'Total Sessions Attended': totalSessionsAttended,
          'Attendance': attendance.toStringAsFixed(2),
        };
      }

      return summary;
    } catch (e) {
      print('Error fetching attendance data: $e');
      return {};
    }
  }

  Future<List<PerformanceRecord>> fetchPerformanceRecordsData(String studentId) async {
    if (studentId.isEmpty) {
      throw Exception('Student ID must not be empty');
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('students')
          .doc(studentId)
          .collection('performanceRecords')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PerformanceRecord.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching performance data: $e');
      throw Exception('Failed to fetch performance data');
    }
  }

//student'sFees
  Future<List<FeesStatus>> fetchFeesStatusData(String studentId) async {
    if (studentId.isEmpty) {
      throw Exception('Student ID must not be empty');
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('students')
          .doc(studentId)
          .collection('feesStatus')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FeesStatus.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching Fees data: $e');
      throw Exception('Failed to fetch fees data');
    }
  }
//student'sFeesPay
  Future<void> payFeesAndSavePayment(
      String feeId,
      String cardNumber,
      String cardHolderName,
      double amountPaid,
      ) async {
    final paymentCollection = _firestore.collection('payments');
    final feeStatusCollection = _firestore.collection('students')
        .doc('O1FsNm0PkQU5i1pQrj2q9yUOknA2') // Replace with actual student ID
        .collection('feeStatus');

    try {
      // Create a new payment document
      DocumentReference paymentRef = paymentCollection.doc();
      await paymentRef.set({
        'studentId': 'O1FsNm0PkQU5i1pQrj2q9yUOknA2', // Replace with actual student ID
        'cardNumber': cardNumber,
        'cardHolderName': cardHolderName,
        'amountPaid': amountPaid,
        'paymentDate': Timestamp.now(),
        'status': 'Paid',
      });

      print('Payment document created successfully.');

      // Update fee status to 'Paid'
      await feeStatusCollection.doc(feeId).update({
        'status': 'Paid',
      });

      print('Fee status updated successfully.');
    } catch (e) {
      print('Error in payFeesAndSavePayment: $e');
      throw e; // Rethrow to handle in UI
    }
  }



  Future<List<Certificates>> fetchCertificatesData(String studentId) async {
    if (studentId.isEmpty) {
      throw Exception('Student ID must not be empty');
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('students')
          .doc(studentId)
          .collection('certificates')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Certificates.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching certificate data: $e');
      throw Exception('Failed to fetch certificate data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchExamsData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('exams').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching exams data: $e');
      return [];
    }
  }

  final CollectionReference _coursesCollection =
  FirebaseFirestore.instance.collection('shortCourses');

  Future<List<shortCourses>> fetchCoursesData() async {
    try {
      QuerySnapshot querySnapshot = await _coursesCollection.get();
      if (querySnapshot.docs.isEmpty) {
        print('No courses found in Firestore.');
      } else {
        print('Total Courses Found: ${querySnapshot.docs.length}');
      }
      return querySnapshot.docs
          .map((doc) => shortCourses.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching courses data: $e');
      return [];
    }
  }

  final CollectionReference _workshopsCollection =
  FirebaseFirestore.instance.collection('workshops');

  Future<List<Workshops>> fetchWorkshopData() async {
    try {
      QuerySnapshot querySnapshot = await _workshopsCollection.get();
      return querySnapshot.docs
          .map((doc) => Workshops.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching workshop data: $e');
      return [];
    }
  }

  Future<void> saveRegistrationForm(Map<String, dynamic> formData) async {
    try {
      await _firestore.collection('registrations').add(formData);
    } catch (e) {
      print('Error saving registration form: $e');
    }
  }

  Future<shortCourses> fetchCourseDetails(String courseId) async {
    try {
      final doc = await _firestore.collection('shortcourses').doc(courseId).get();
      if (doc.exists) {
        return shortCourses.fromSnapshot(doc);
      } else {
        throw Exception('Course not found');
      }
    } catch (e) {
      throw Exception('Error fetching course details: $e');
    }
  }

  final CollectionReference _sessionsCollection =
  FirebaseFirestore.instance.collection('sessions');

  Future<List<Session>> fetchSessionsData() async {
    try {
      QuerySnapshot querySnapshot = await _sessionsCollection.get();
      if (querySnapshot.docs.isEmpty) {
        print('No sessions found in Firestore.');
      } else {
        print('Total sessions found: ${querySnapshot.docs.length}');
      }
      return querySnapshot.docs
          .map((doc) => Session.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching sessions data: $e');
      return [];
    }
  }
  // Save quiz score
  Future<void> saveQuizScore({required String studentId, required int score}) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .collection('scores')
          .add({
        'quizScore': score,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to save score: $e');
    }
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../models/Exams.dart';
import '../../../models/FeesStatus.dart';
import '../../../models/payment.dart';
import '../../../models/sessions.dart';
import '../../../models/student_performance.dart';
import '../../../models/workshop.dart';

class FacultyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch Faculty Details
  Future<Map<String, dynamic>?> getFacultyData(String facultyId) async {
    try {
      final facultyDoc = await _db.collection('faculty').doc(facultyId).get();
      if (facultyDoc.exists) {
        return facultyDoc.data();
      } else {
        print('Faculty not found');
        return null;
      }
    } catch (e) {
      print('Error fetching faculty data: $e');
      return null;
    }
  }

  // Fetch Students Managed by Faculty
  Stream<List<Map<String, dynamic>>> getManagedStudents(String facultyId) {
    return _db.collection('faculty').doc(facultyId).snapshots().asyncMap((
        doc) async {
      if (doc.exists) {
        List<String> studentIds = List<String>.from(
            doc.data()?['managedStudents'] ?? []);
        studentIds = studentIds.map((id) => id.trim()).toList();

        if (studentIds.isNotEmpty) {
          try {
            QuerySnapshot studentSnapshot = await _db.collection('students')
                .where(FieldPath.documentId, whereIn: studentIds)
                .get();
            List<Map<String, dynamic>> students = studentSnapshot.docs.map((
                doc) => doc.data() as Map<String, dynamic>).toList();
            return students;
          } catch (e) {
            print('Error fetching students: $e');
            return <Map<String, dynamic>>[];
          }
        } else {
          return <Map<String, dynamic>>[];
        }
      } else {
        return <Map<String, dynamic>>[];
      }
    }).handleError((e) {
      print('Error fetching managed students: $e');
      return <Map<String, dynamic>>[];
    });
  }

  // Fetch a Student's Subcollection Data (e.g., assignments, attendance, etc.)
  Future<List<Map<String, dynamic>>> getStudentSubcollectionData(
      String studentId, String subcollectionName) async {
    try {
      QuerySnapshot subcollectionSnapshot = await _db.collection('students')
          .doc(studentId)
          .collection(subcollectionName)
          .get();

      return subcollectionSnapshot.docs.map((doc) =>
      doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching $subcollectionName data: $e');
      return [];
    }
  }

  // Add Data to a Student's Subcollection
  Future<void> addStudentSubcollectionData(String studentId,
      String subcollectionName, Map<String, dynamic> data) async {
    try {
      await _db.collection('students')
          .doc(studentId)
          .collection(subcollectionName)
          .add(data);
    } catch (e) {
      print('Error adding data to $subcollectionName: $e');
      throw e;
    }
  }

  // Update Data in a Student's Subcollection
  Future<void> updateStudentSubcollectionData(String studentId,
      String subcollectionName, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _db.collection('students')
          .doc(studentId)
          .collection(subcollectionName)
          .doc(documentId)
          .update(data);
    } catch (e) {
      print('Error updating data in $subcollectionName: $e');
      throw e;
    }
  }

  // Delete Data from a Student's Subcollection
  Future<void> deleteStudentSubcollectionData(String studentId,
      String subcollectionName, String documentId) async {
    try {
      await _db.collection('students')
          .doc(studentId)
          .collection(subcollectionName)
          .doc(documentId)
          .delete();
    } catch (e) {
      print('Error deleting data from $subcollectionName: $e');
      throw e;
    }
  }

  // Upload Image to Firebase Storage
  Future<String> uploadImage(File imageFile, String folderPath) async {
    try {
      String fileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Reference storageReference = _storage.ref().child(
          '$folderPath/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }


  // Update Faculty Profile
  Future<void> updateFacultyProfile(String facultyId,
      {String? name, String? phone, File? imageFile}) async {
    try {
      Map<String, dynamic> updatedData = {};

      if (name != null) {
        updatedData['name'] = name;
      }

      if (phone != null) {
        updatedData['phone'] = phone;
      }

      if (imageFile != null) {
        String imageUrl = await uploadImage(imageFile, 'faculty_profiles');
        updatedData['imageUrl'] = imageUrl;
      }

      if (updatedData.isNotEmpty) {
        await _db.collection('faculty').doc(facultyId).update(updatedData);
      }
    } catch (e) {
      print('Error updating faculty profile: $e');
      throw e;
    }
  }


  // Fetch all workshops
  Future<List<Map<String, dynamic>>> getAllWorkshops() async {
    try {
      QuerySnapshot snapshot = await _db.collection('workshops').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Ensure the 'date' field is a string
        if (data.containsKey('date') && data['date'] is Timestamp) {
          Timestamp timestamp = data['date'] as Timestamp;
          data['date'] = timestamp.toDate()
              .toLocal()
              .toString(); // Convert Timestamp to readable String
        }

        return data;
      }).toList();
    } catch (e) {
      print('Error fetching workshops: $e');
      return [];
    }
  }

  Future<void> addWorkshop(Map<String, dynamic> workshop) async {
    try {
      await _db.collection('workshops').add(workshop);
    } catch (e) {
      print('Error adding workshop: $e');
    }
  }
  // Method to update a workshop
  Future<void> updateWorkshop(String workshopId, Map<String, dynamic> workshopData) async {
    await _db.collection('workshops').doc(workshopId).update(workshopData);
  }

  Future<void> deleteWorkshop(String workshopId) async {
    try {
      await _db.collection('workshops').doc(workshopId).delete();
    } catch (e) {
      print('Error deleting workshop: $e');
    }
  }

  // Fetch all exams
  Future<List<Exam>> getAllExams() async {
    try {
      QuerySnapshot snapshot = await _db.collection('exams').get();
      return snapshot.docs.map((doc) =>
          Exam.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching exams: $e');
      return [];
    }
  }

  // Add a new exam
  Future<void> addExam(Map<String, dynamic> data) async {
    try {
      await _db.collection('exams').add(data);
    } catch (e) {
      print('Error adding exam: $e');
    }
  }

  // Delete an exam
  Future<void> deleteExam(String docId) async {
    try {
      await _db.collection('exams').doc(docId).delete();
    } catch (e) {
      print('Error deleting exam: $e');
    }
  }




  // Fetch Performance Records
  Future<List<Map<String, dynamic>>> getPerformanceRecords(String studentId) async {
  try {
  QuerySnapshot snapshot = await _db.collection('students')
      .doc(studentId)
      .collection('performanceRecords')
      .get();

  return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } catch (e) {
  print('Error fetching performance records: $e');
  return [];
  }
  }

  // Update Performance Record
  Future<void> updatePerformanceRecord(String studentId, String recordId, Map<String, dynamic> updatedData) async {
  try {
  await _db.collection('students')
      .doc(studentId)
      .collection('performanceRecords')
      .doc(recordId)
      .update(updatedData);
  print('Performance record updated successfully.');
  } catch (e) {
  print('Error updating performance record: $e');
  throw e;
  }
  }

  // Delete Performance Record
  Future<void> deletePerformanceRecord(String studentId, String recordId) async {
  try {
  await _db.collection('students')
      .doc(studentId)
      .collection('performanceRecords')
      .doc(recordId)
      .delete();
  print('Performance record deleted successfully.');
  } catch (e) {
  print('Error deleting performance record: $e');
  throw e;
  }
  }

  // Add Performance Record
  Future<void> addPerformanceRecord(String studentId, Map<String, dynamic> newRecordData) async {
  try {
  await _db.collection('students')
      .doc(studentId)
      .collection('performanceRecords')
      .add(newRecordData);
  print('Performance record added successfully.');
  } catch (e) {
  print('Error adding performance record: $e');
  throw e;
  }
  }

  final CollectionReference _sessionsCollection =
  FirebaseFirestore.instance.collection('sessions');

  Future<List<Session>> fetchSessionsData() async {
    try {
      QuerySnapshot querySnapshot = await _sessionsCollection.get();
      return querySnapshot.docs.map((doc) => Session.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching sessions data: $e');
      return [];
    }
  }

  Future<void> addSession({
    required String title,
    required String date,
    required String time,
    required String faculty,
    required String zoomLink,
  }) async {
    try {
      await _sessionsCollection.add({
        'title': title,
        'date': date,
        'time': time,
        'faculty': faculty,
        'zoomLink': zoomLink,
      });
    } catch (e) {
      print('Error adding session: $e');
    }
  }

  Future<void> updateSession({
    required String id,
    required String title,
    required String date,
    required String time,
    required String faculty,
    required String zoomLink,
  }) async {
    try {
      await _sessionsCollection.doc(id).update({
        'title': title,
        'date': date,
        'time': time,
        'faculty': faculty,
        'zoomLink': zoomLink,
      });
    } catch (e) {
      print('Error updating session: $e');
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      await _sessionsCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting session: $e');
    }
  }

  //FEES MANAGES//
  Future<void> addFeesStatus(String studentId, FeesStatus feesStatus) async {
    try {
      final feesCollection = FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .collection('feesStatus');

      await feesCollection.add(feesStatus.toMap());
      print('Fees status added successfully!');
    } catch (e) {
      print('Error adding fees status: $e');
    }
  }

  Future<void> updateFeesStatus(String studentId, String feeId, FeesStatus feesStatus) async {
    try {
      final feesDocument = FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .collection('feesStatus')
          .doc(feeId);

      await feesDocument.update(feesStatus.toMap());
      print('Fees status updated successfully!');
    } catch (e) {
      print('Error updating fees status: $e');
    }
  }

  Future<void> deleteFeesStatus(String studentId, String feeId) async {
    try {
      final feesDocument = FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .collection('feesStatus')
          .doc(feeId);

      await feesDocument.delete();
      print('Fees status deleted successfully!');
    } catch (e) {
      print('Error deleting fees status: $e');
    }
  }

  Future<List<FeesStatus>> fetchFeesStatus(String studentId) async {
    try {
      final feesSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .collection('feesStatus')
          .get();

      return feesSnapshot.docs.map((doc) {
        return FeesStatus.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching fees status: $e');
      return [];
    }
  }


  // Fetch all payments (example usage, not necessarily required)
  Future<List<Payment>> fetchPaymentsForStudent(String studentId) async {
    try {
      // Fetch student name
      DocumentSnapshot studentSnapshot = await _db.collection('students').doc(studentId).get();
      String studentName = (studentSnapshot.data() as Map<String, dynamic>)['name'] ?? 'Unknown';

      // Firestore query to fetch payments for a specific student ID
      final querySnapshot = await _db.collection('payments').where('studentId', isEqualTo: studentId).get();

      // If no documents are found
      if (querySnapshot.docs.isEmpty) {
        print('No payments found for studentId: $studentId');
        return [];
      }

      // Mapping each document into a Payment object
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        return Payment.fromFirestore({
          ...data,
          'studentName': studentName,
        }, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching payments: $e');
      throw Exception('Failed to fetch payments: $e');
    }
  }
  // Update the payment status for a specific fee
  Future<void> updatePaymentStatus(String feeId, String status) async {
    try {
      await _db.collection('fees').doc(feeId).update({'status': status});
    } catch (e) {
      print('Error updating payment status: $e');
      throw Exception('Failed to update payment status: $e');
    }
  }
}








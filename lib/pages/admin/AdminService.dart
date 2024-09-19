import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../models/sessions.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch admin Details
  Future<Map<String, dynamic>?> getAdminData(String adminId) async {
    try {
      final adminDoc= await _db.collection('admin').doc(adminId).get();
      if (adminDoc.exists) {
        return adminDoc.data();
      } else {
        print('Admin not found');
        return null;
      }
    } catch (e) {
      print('Error fetching admin data: $e');
      return null;
    }
  }

  // Fetch Students Managed by admin
  Stream<List<Map<String, dynamic>>> getManagedStudents(String adminId) {
    return _db.collection('admin').doc(adminId).snapshots().asyncMap((
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
  Future<void> updateAdminProfile(String adminId,
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
        await _db.collection('admin').doc(adminId).update(updatedData);
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
}











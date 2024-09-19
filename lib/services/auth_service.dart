import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:aptech_clifton/models/student.dart';

class FirebaseAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create Student object from FirebaseUser
  Student? _studentFromFirebaseUser(auth.User? user, Map<String, dynamic>? userData) {
    return user != null
        ? Student(
      id: user.uid,
      name: userData?['name'] ?? '',
      email: user.email!,
      phone: userData?['phone'] ?? '',
      address: userData?['address'] ?? '',
      enrollmentDate: userData?['enrollmentDate'] ?? Timestamp.fromDate(DateTime.now()),
      imageUrl: userData?['imageUrl'] ?? 'assets/images/default_image.png',
      role: userData?['role'] ?? '',
    )
        : null;
  }

  // Auth change user stream
  Stream<Student?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        final userData = await _fetchUserData(user.uid);
        return _studentFromFirebaseUser(user, userData);
      } catch (e) {
        print('Error fetching user data: $e');
        return null;
      }
    });
  }

  // Helper method to fetch user data based on role
  Future<Map<String, dynamic>?> _fetchUserData(String uid) async {
    try {
      // Check in student collection
      final studentDoc = await _db.collection('student').doc(uid).get();
      if (studentDoc.exists) {
        return studentDoc.data();
      }

      // Check in faculty collection
      final facultyDoc = await _db.collection('faculty').doc(uid).get();
      if (facultyDoc.exists) {
        return facultyDoc.data();
      }

      // Check in admin collection
      final adminDoc = await _db.collection('admin').doc(uid).get();
      if (adminDoc.exists) {
        return adminDoc.data();
      }

      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final auth.User? user = result.user;

      if (user != null) {
        final userData = await _fetchUserData(user.uid);
        print('User data fetched: $userData');

        // Determine the route based on the role
        String route = '/home'; // Default to student home

        if (userData != null && userData['role'] != null) {
          if (userData['role'] == 'admin') {
            route = '/admin_dashboard';
          } else if (userData['role'] == 'faculty') {
            route = '/faculty_dashboard';
          }
        }

        // Return both the user object and the route
        return {
          'user': _studentFromFirebaseUser(user, userData),
          'route': route,
        };
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Register with email, password, and other details
  Future<Student?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    required Timestamp enrollmentDate,
    required String imageUrl,
    required String role,
  }) async {
    try {
      final auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final auth.User? user = result.user;

      if (user != null) {
        Map<String, dynamic> userData = {
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'enrollmentDate': enrollmentDate,
          'imageUrl': imageUrl,
          'role': role,
        };

        // Save data to the appropriate collection based on role
        if (role == 'student') {
          await _db.collection('student').doc(user.uid).set(userData);
        } else if (role == 'faculty') {
          await _db.collection('faculty').doc(user.uid).set(userData);
        } else if (role == 'admin') {
          await _db.collection('admin').doc(user.uid).set(userData);
        }

        print('User registered and data saved');
        return _studentFromFirebaseUser(user, userData);
      }
      return null;
    } catch (e) {
      print('Error registering: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Fetch Students
  Stream<List<Student>> getStudents() {
    return _db.collection('students').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Student.fromDocument(doc)).toList());
  }

  // Fetch Faculty
  Stream<List<Student>> getFaculty() {
    return _db.collection('faculty').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Student.fromDocument(doc)).toList());
  }

  // Fetch Admins (Optional)
  Stream<List<Student>> getAdmins() {
    return _db.collection('admin').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Student.fromDocument(doc)).toList());
  }

  // Update User
  Future<void> updateUser(String id, Map<String, dynamic> data, String role) {
    return _db.collection(role).doc(id).update(data);
  }

  // Delete User
  Future<void> deleteUser(String id, String role) {
    return _db.collection(role).doc(id).delete();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aptech_clifton/pages/faculty/faculty_dashboard.dart';
import 'package:aptech_clifton/pages/student/home_page.dart'; // Updated import
import '../admin/admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = auth.FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final auth.User? user = result.user;

      if (user != null) {
        // Pehle student collection check karein
        final studentDoc = await _db.collection('students').doc(user.uid).get();
        if (studentDoc.exists) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(studentId: user.uid),
            ),
          );
          return;
        }

        // Phir faculty collection check karein
        final facultyDoc = await _db.collection('faculty').doc(user.uid).get();
        if (facultyDoc.exists) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => FacultyDashboard(),
            ),
          );
          return;
        }

        // Phir admin collection check karein
        final adminDoc = await _db.collection('admin').doc(user.uid).get();
        if (adminDoc.exists) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AdminDashboard(),
            ),
          );
          return;
        }

        // Agar koi bhi collection main document na mile to error throw karein
        throw Exception("User not found in any collection.");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Opacity(
            opacity: 0.6, // Adjust opacity as needed
            child: Image.asset(
              'assets/images/lbg.jpg', // Update with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Centered Card
          Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Aptech Logo
                    Image.asset(
                      'assets/images/logo (1).png',
                      height: 80,
                    ),
                    SizedBox(height: 20),
                    // Email Field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Password Field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Error Message
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 16),
                    // Login Button
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(300, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aptech_clifton/pages/admin/AdminService.dart';
import 'package:aptech_clifton/pages/admin/Admin_Profile.dart';
import 'package:aptech_clifton/pages/admin/Attendance_system.dart';
import 'package:aptech_clifton/pages/admin/admin_dashboard.dart';
import 'package:aptech_clifton/pages/faculty/faculty_profile_page.dart';
import 'package:aptech_clifton/pages/faculty/faculty_services/FacultyService.dart';
import 'package:aptech_clifton/pages/faculty/manage_sessions.dart';
import 'package:aptech_clifton/pages/student/CoursesListPage.dart';
import 'package:aptech_clifton/pages/student/profile_settings.dart';
import 'package:aptech_clifton/pages/student/sessions_page.dart';
import 'package:aptech_clifton/pages/student/student_performance_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aptech_clifton/pages/student/home_page.dart';
import 'package:aptech_clifton/pages/student/login.dart';
import 'package:aptech_clifton/pages/student/splash_screen.dart';
import 'package:aptech_clifton/pages/student/explore_page.dart';
import 'package:aptech_clifton/pages/student/attendance_page.dart';
import 'package:aptech_clifton/pages/student/fees_status_page.dart';
import 'package:aptech_clifton/pages/student/certificate_page.dart';
import 'package:aptech_clifton/pages/student/my_exam_page.dart';

import 'package:aptech_clifton/pages/faculty/faculty_dashboard.dart'; // Add this import
import 'package:aptech_clifton/services/auth_service.dart';
import 'firebase_options.dart'; // Ensure this file is configured correctly

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        Provider<FacultyService>(create: (_) => FacultyService()),
        Provider<AdminService>(create: (_) => AdminService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aptech Clifton',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),

      ),

      initialRoute: '/', // Start with splash screen
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasData && userSnapshot.data != null) {
                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    final role = userData['role'];

                    if (role == 'student') {
                      return HomePage(studentId: snapshot.data!.uid);
                    } else if (role == 'faculty') {
                      return FacultyDashboard();
                    }
                    else if (role == 'admin') {
                      return AdminDashboard();
                    }
                  }
                  return LoginPage(); // Default fallback
                },
              );
            } else {
              return LoginPage();
            }
          },
        ),
        '/explore': (context) => ExplorePage(),
        '/performance_record': (context) => StudentPerformancePage(),
        '/attendance': (context) => AttendancePage(studentId: '',),
        '/fees_status': (context) => FeesStatusPage(),
        '/Session Attendance': (context) => AttendanceSystem(),
        '/certificate': (context) => CertificatePage(),
        '/my_exam': (context) => MyExamPage(),
        '/Sessions': (context) =>  SessionsPage(),
        '/courses': (context) => CoursesListPage(),
        '/Profile Settings': (context) => FacultyProfilePage(),
        '/Profile Settings': (context) => AdminProfilePage(),
        '/StudentsProfileSettings': (context) => StudentProfilePage(),
        '/manage_sessions': (context) => ManageSessionsPage(),
        // Define additional routes here as needed
      },
    );
  }
}

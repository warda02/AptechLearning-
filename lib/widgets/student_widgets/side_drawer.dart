import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:aptech_clifton/services/auth_service.dart';
import '../../pages/student/ApplicationForm.dart';
import '../../pages/student/attendance_page.dart';
import '../../pages/student/certificate_page.dart';
import '../../pages/student/fees_status_page.dart';
import '../../pages/student/my_exam_page.dart';
import '../../pages/student/profile_settings.dart';
import '../../pages/student/student_performance_page.dart';
import '../../pages/student/workshop_page.dart';
import '../../pages/student/CoursesListPage.dart';

class SideDrawer extends StatelessWidget {
  final String studentName;
  final String studentImageUrl;

  SideDrawer({
    required this.studentName,
    required this.studentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,

            child: DrawerHeader(
              decoration: BoxDecoration(
                color:Color(0xFFFEBE10) ,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(studentImageUrl),
                    onBackgroundImageError: (error, stackTrace) {
                      // Handle image loading errors
                      print('Error loading image: $error');
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    studentName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/performance.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Performance Record'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentPerformancePage()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Attendance'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AttendancePage(studentId: '',)),
                    );
                  },
                ),

                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/certificate.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Certificate'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CertificatePage()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/fees.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Fees'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeesStatusPage()),
                    );
                  },
                ),


                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/courses.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Application'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApplicationFormPage()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/logout.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('ProfileSettings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentProfilePage()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/user.svg',

                     color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Logout'),
                  onTap: () async {
                    // Access FirebaseAuthService using Provider
                    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
                    await authService.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

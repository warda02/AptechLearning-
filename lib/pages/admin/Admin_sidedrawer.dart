import 'package:aptech_clifton/pages/admin/Admin_Profile.dart';
import 'package:aptech_clifton/pages/admin/Batch_system.dart';
import 'package:aptech_clifton/pages/admin/exams.dart';
import 'package:aptech_clifton/pages/admin/sessions.dart';
import 'package:aptech_clifton/pages/admin/workshops.dart';
import 'package:aptech_clifton/pages/faculty/ManageAssignments.dart';
import 'package:aptech_clifton/pages/faculty/ManagePerformanceRecords.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import 'Attendance_system.dart';

class AdminSidedrawer extends StatelessWidget {
  final String adminName;
  final String adminImageUrl;

  AdminSidedrawer({
    required this.adminName,
    required this.adminImageUrl,
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
                    backgroundImage: NetworkImage(adminImageUrl),
                    onBackgroundImageError: (error, stackTrace) {
                      // Handle image loading errors
                      print('Error loading image: $error');
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    adminName,
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
                    'assets/icons/exam.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('View Exam'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewExams()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/workshop.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('View Workshops'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewWorkshops()),
                    );
                  },
                ),
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
                      MaterialPageRoute(builder: (context) => ManagePerformanceRecordPage()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/batch.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('BatchesDetails'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  BatchSystem()),
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
                  title: Text('ManageSessions'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ManageSession()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/assignments.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('ManageAssignments'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ManageAssignmentsPage()),
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
                  title: Text('ManageAttendance'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AttendanceSystem()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/setting.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('ProfileSettings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AdminProfilePage()),
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

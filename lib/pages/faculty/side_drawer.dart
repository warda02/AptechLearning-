import 'package:aptech_clifton/pages/faculty/ManageWorkshops.dart';
import 'package:aptech_clifton/pages/faculty/faculty_profile_page.dart';
import 'package:aptech_clifton/pages/faculty/manage_sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import 'ManageAssignments.dart';
import 'ManageAttendance.dart';
import 'ManageCertificates.dart';
import 'ManageExams.dart';
import 'ManageFeesStatus.dart';
import 'ManagePerformanceRecords.dart';
import 'PaymentListScreen.dart';
import 'add_fees_challan.dart';

class SideDrawer extends StatelessWidget {
  final String facultyName;
  final String facultyImageUrl;

  SideDrawer({
    required this.facultyName,
    required this.facultyImageUrl,
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
                color: Color(0xFFFEBE10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: facultyImageUrl.isNotEmpty
                        ? NetworkImage(facultyImageUrl)
                        : AssetImage('assets/images/default_image.png') as ImageProvider,
                    onBackgroundImageError: (error, stackTrace) {
                      print('Error loading image: $error');
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    facultyName,
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
                    'assets/icons/calendar.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('ManagePerAttendance'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageAttendancePage()),
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
                  title: Text('ManageCertificate'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageCertificatePage()),
                    );
                  },
                ),

                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/exam.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Manage Exam'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageExamsPage()),
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
                  title: Text('Manage Workshops'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ManageWorkshopsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/fees.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Manage fees'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AddFeesChalan()),
                    );
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/fees.svg',
                    color: Colors.black,
                    width: 24,
                    height: 24,
                  ),
                  title: Text('PaidStudentList'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>   PaymentListPage(studentId: 'O1FsNm0PkQU5i1pQrj2q9yUOknA2')),
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
                      MaterialPageRoute(builder: (context) =>  ManageSessionsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('ProfileSettings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  FacultyProfilePage()),
                    );
                  },
                ),

                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
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

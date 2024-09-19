import 'package:aptech_clifton/pages/student/profile_settings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aptech_clifton/pages/student/CoursesListPage.dart';
import 'package:aptech_clifton/pages/student/explore_page.dart';
import 'package:aptech_clifton/pages/student/fees_status_page.dart';
import 'package:aptech_clifton/pages/student/sessions_page.dart';
import 'package:aptech_clifton/widgets/student_widgets/bottom_navigation_bar.dart';
import 'package:aptech_clifton/widgets/student_widgets/side_drawer.dart'; // Import the SideDrawer
import '../../models/student.dart';
import 'events.dart';
import 'home_content.dart';

class HomePage extends StatefulWidget {
  final String studentId;

  HomePage({required this.studentId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Student? _student;

  final List<Widget> _pages = [
    HomeContent(),
    EventsPage(),
    CoursesListPage(),
    ExplorePage()
  ];

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .get();

      if (doc.exists) {
        setState(() {
          _student = Student.fromDocument(doc);
        });
      } else {
        print('Student document does not exist');
      }
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notification 1'),
                subtitle: Text('This is a description for notification 1.'),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notification 2'),
                subtitle: Text('This is a description for notification 2.'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentProfilePage()), // Navigate to the ProfileSettingsPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true, // Keep the AppBar visible when scrolling
            floating: false, // Disable floating effect
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo (1).png',
                  height: 40,
                ),
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () => _showNotifications(context),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.black), // Settings icon
                onPressed: () => _navigateToSettings(context), // Navigate to settings page
              ),
            ],
          ),
          SliverFillRemaining(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      drawer: _student == null
          ? null
          : SideDrawer(
        studentName: _student!.name,
        studentImageUrl: _student!.imageUrl ?? 'https://via.placeholder.com/80',
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

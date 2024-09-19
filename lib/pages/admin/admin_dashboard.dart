import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'AdminService.dart';
import 'Admin_sidedrawer.dart';

class AdminDashboard extends StatelessWidget {
  final String adminId = 'N8RV0GhXa8YfmoVPtMi7pvNDo4x1';

  @override
  Widget build(BuildContext context) {
    final adminService = Provider.of<AdminService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('FACULTY DAHSBOARD'),
        backgroundColor: Color(0xFFFEBE10) ,
      ),
      drawer: FutureBuilder<Map<String, dynamic>?>(
        future: adminService.getAdminData(adminId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Drawer(
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Drawer(
              child: Center(child: Text('Admin not found')),
            );
          } else {
            final adminData = snapshot.data!;
            return AdminSidedrawer(
              adminName: adminData['name'] ?? 'No Name',
              adminImageUrl: adminData['imageUrl'] ?? 'assets/images/default_image.png',
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(adminId, adminService),

            SizedBox(height: 16),

            // Carousel for announcements
            _buildCarousel(),


          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String adminId, AdminService adminService) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: adminService.getAdminData(adminId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Admin not found'));
        } else {
          final adminData = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${adminData['name'] ?? 'Admin'}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Here is your dashboard overview',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          );
        }
      },
    );
  }
  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: [
        _buildCarouselCard('assets/images/assignments.png'),
        _buildCarouselCard('assets/images/assignments.png'),
        _buildCarouselCard('assets/images/workshops.png'),
        _buildCarouselCard('assets/images/workshops.png'),
      ],
    );
  }

  Widget _buildCarouselCard(String imageUrl) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
  Widget _buildOverviewCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOverviewCard(Icons.assignment, 'Notes', Colors.blue),
        _buildOverviewCard(Icons.event, 'Events', Colors.orange),
        _buildOverviewCard(Icons.chat, 'Messages', Colors.green),
      ],
    );
  }

  Widget _buildOverviewCard(IconData icon, String title, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 100,
        height: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 8),
            Text('75% of tasks completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        _buildTaskTile('Assignment Grading', 0.6),
        _buildTaskTile('Lecture Preparation', 0.8),
        _buildTaskTile('Student Feedback', 0.4),
      ],
    );
  }

  Widget _buildTaskTile(String task, double progress) {
    return Column(
      children: [
        ListTile(
          title: Text(task),
          subtitle: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        _buildEventTile('Workshop on Flutter', 'Sep 25, 2024'),
        _buildEventTile('Guest Lecture: AI in Education', 'Oct 10, 2024'),
      ],
    );
  }

  Widget _buildEventTile(String event, String date) {
    return ListTile(
      leading: Icon(Icons.event, color: Colors.orange),
      title: Text(event),
      subtitle: Text(date),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildActivityTile('Activity 1', 'Details of activity 1'),
        _buildActivityTile('Activity 2', 'Details of activity 2'),
        _buildActivityTile('Activity 3', 'Details of activity 3'),
      ],
    );
  }

  Widget _buildActivityTile(String title, String description) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text(title),
      subtitle: Text(description),
      trailing: Icon(Icons.arrow_forward),
    );
  }
}

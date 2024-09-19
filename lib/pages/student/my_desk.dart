import 'package:flutter/material.dart';
import '../../models/student.dart';

class MyDeskPage extends StatefulWidget {
  final Student student; // Declare a student property

  MyDeskPage({required this.student});

  @override
  _MyDeskPageState createState() => _MyDeskPageState();
}

class _MyDeskPageState extends State<MyDeskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Desk',
          style: TextStyle(
            color: Colors.white, // Text color
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: Color(0xFFFEBE10), // Background color
        elevation: 0, // Optional: Remove shadow
      ),
      body: Column(
        children: [
          // Banner with image carousel
          Container(
            height: 200,
            child: PageView(
              children: [
                Image.asset('assets/images/banner1.webp', fit: BoxFit.cover),
                Image.asset('assets/images/banner2.webp', fit: BoxFit.cover),
                Image.asset('assets/images/banner2.webp', fit: BoxFit.cover),
              ],
            ),
          ),
          // Cards with icons in a grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of cards per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // Aspect ratio for the card
              ),
              itemCount: 6, // Number of items
              itemBuilder: (context, index) {
                final options = [
                  {'icon': Icons.show_chart, 'title': 'Performance Record'},
                  {'icon': Icons.calendar_today, 'title': 'Attendance'},
                  {'icon': Icons.monetization_on, 'title': 'Fees Status'},
                  {'icon': Icons.assessment, 'title': 'Performance Statement'},
                  {'icon': Icons.star, 'title': 'Certificate'},
                  {'icon': Icons.pages, 'title': 'My Exam'},
                ];

                final option = options[index];
                return _buildOptionCard(option['icon'] as IconData, option['title'] as String);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each card
  Widget _buildOptionCard(IconData icon, String title) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

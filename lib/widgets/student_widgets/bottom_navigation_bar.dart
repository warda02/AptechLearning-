import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  CustomBottomNavigationBar({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CircleNavBar(
      activeIndex: selectedIndex,
      activeIcons: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.class_, color: Colors.white),
        Icon(Icons.details, color: Colors.white),
        Icon(Icons.library_books, color: Colors.white),
      ],
      inactiveIcons: [
        Text("Home", style: TextStyle(color: selectedIndex == 0 ? Color(0xFFFEBE10) : Colors.black)),
        Text("Events", style: TextStyle(color: selectedIndex == 1 ? Color(0xFFFEBE10) : Colors.black)),
        Text("Courses", style: TextStyle(color: selectedIndex == 2 ? Color(0xFFFEBE10) : Colors.black)),
         Text("Explore", style: TextStyle(color: selectedIndex == 4 ? Color(0xFFFEBE10) : Colors.black)),
      ],
      color: Colors.white, // Background color of the navigation bar
      circleColor: Color(0xFFFEBE10), // Circle color
      height: 60,
      circleWidth: 60,
      onTap: (index) {
        onItemTapped(index);
      },
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      cornerRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
      ),
      elevation: 10,
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFFEBE10), Color(0xFFFEBE10)],
      ),
      circleGradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFFEBE10), Color(0xFFFEBE10)],
      ),
    );
  }
}

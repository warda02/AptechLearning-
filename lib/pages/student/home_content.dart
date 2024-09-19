import 'package:aptech_clifton/pages/student/my_exam_page.dart';
import 'package:aptech_clifton/pages/student/sessions_page.dart';
import 'package:aptech_clifton/pages/student/workshop_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aptech_clifton/pages/student/QuizPage.dart';
import '../../json/home_page_json.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../widgets/custom_slider.dart';
import 'CoursesListPage.dart';
import 'explore_page.dart';

// Define your categories list with updated names if needed
const List categories = [
  {"img": "assets/images/workk.svg", "name": "Workshops"},
  {"img": "assets/images/examm.svg", "name": "Exams"},
  {"img": "assets/images/gamy.svg", "name": "Games"},
  {"img": "assets/images/events.svg", "name": "Sessions"},
];

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int activeMenu = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 15),
          // Custom Slider
          CustomSliderWidget(
            items: [
              "assets/images/slider1.png",
              "assets/images/slider2.jpg",
              "assets/images/slider3.jpg",
            ],
          ),
          SizedBox(height: 15),
          // Categories Section
          Container(
            width: size.width,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to different pages based on the category
                                switch (categories[index]['name']) {
                                  case 'Workshops':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkshopPage(),
                                      ),
                                    );
                                    break;
                                  case 'Exams':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyExamPage(),
                                      ),
                                    );
                                    break;
                                  case 'Games':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(),
                                      ),
                                    );
                                    break;
                                  case 'Sessions':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SessionsPage(),
                                      ),
                                    );
                                    break;
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        categories[index]['img']!,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    categories[index]['name']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),

          // Featured Course Section
          buildMenuSection(
            context,
            menuData: firstMenu[0], // Use the first item from firstMenu list
            sectionTitle: 'Featured Course',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CoursesListPage(),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          // Divider
          Container(
            width: size.width,
            height: 10,
            decoration: BoxDecoration(color: textFieldColor),
          ),
          SizedBox(height: 20),
          // More to Explore Section
          buildHorizontalListSection(
            context,
            sectionTitle: "More to Explore",
            items: exploreMenu, // Use exploreMenu data
            onTap: (img) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExplorePage(),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          // Divider
          Container(
            width: size.width,
            height: 10,
            decoration: BoxDecoration(color: textFieldColor),
          ),
          SizedBox(height: 20),
          // About Us Section
          buildHorizontalListSection(
            context,
            sectionTitle: "ABOUT US",
            items: AboutUs, // Use AboutUs data
            onTap: (img) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExplorePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper Widget for Slider Section
  Widget buildSliderSection(BuildContext context, {
    required List<Map<String, dynamic>> items,
    required String sectionTitle,
    required Function(String) onTap,
  }) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: customTitle,
            ),
            SizedBox(height: 15),
            Container(
              height: 200, // Height for slider
              child: CarouselSlider.builder(
                itemCount: items.length,
                itemBuilder: (context, index, realIndex) {
                  var item = items[index];
                  return GestureDetector(
                    onTap: () => onTap(item['img']),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white, // Background color for the card
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                item['img'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.1),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      item['time'],
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widget for Menu Section
Widget buildMenuSection(BuildContext context, {
  required Map<String, dynamic> menuData,
  required String sectionTitle,
  required VoidCallback onTap,
}) {
  var size = MediaQuery
      .of(context)
      .size;
  return Container(
    width: size.width,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: customTitle,
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: size.width,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(menuData['img']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.1)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menuData['name'],
                          style: TextStyle(
                            color: white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          menuData['time'],
                          style: TextStyle(
                            color: white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildHorizontalListSection(BuildContext context, {
  required String sectionTitle,
  required List<Map<String, dynamic>> items,
  required Function(String) onTap,
}) {
  var size = MediaQuery
      .of(context)
      .size;
  return Container(
    width: size.width,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: customTitle,
          ),
          SizedBox(height: 15),
          Container(
            height: 200, // Increased height for better card display
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () => onTap(item['img']),
                    child: Container(
                      width: size.width * 0.6, // Adjust width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white, // Background color for the card
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                item['img'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.1),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      item['time'],
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

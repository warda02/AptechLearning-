import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  // A list of image URLs or asset paths
  final List<String> eventImages = [
    'assets/images/aboutimg.jpg',
    'assets/images/aboutimg.jpg',
    'assets/images/award.jpg',
    'assets/images/award.jpg',
    'assets/images/aboutimg.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of images per row
            crossAxisSpacing: 10, // Horizontal spacing between images
            mainAxisSpacing: 10,  // Vertical spacing between images
          ),
          itemCount: eventImages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // When an image is tapped, you can show a full-screen image or more details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsPage(imagePath: eventImages[index]),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    eventImages[index],
                    fit: BoxFit.cover, // Ensures the image covers the card
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Event Details Page to show full-screen image or more details
class EventDetailsPage extends StatelessWidget {
  final String imagePath;

  EventDetailsPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Center(
        child: Image.asset(imagePath),
      ),
    );
  }
}

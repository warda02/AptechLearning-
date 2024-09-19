import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<String> imgList = [
    'assets/images/homesp.png',
    'assets/images/mainimg.jpg',
    'assets/images/aboutimg.jpg',
  ];

  final List<Map<String, dynamic>> featureList = [
    {
      'title': 'About Aptech',
      'color': Color(0xFFFEBE10),
      'content': '''
        Aptech Pakistan is a premier institute for technical education, dedicated to providing students with the knowledge and skills they need to succeed in the ever-evolving world of technology. With over 30 years of experience in designing courses and providing topnotch education to students, Aptech Pakistan is the go-to choice for students who want to excel in their careers.
        
        At Aptech Pakistan, we offer a wide range of technical education courses, including Information Technology, Multimedia & Animation, Hardware & Networking, and Aviation & Hospitality. Our courses are designed to provide students with a rigorous and challenging learning experience that prepares them for the real-world challenges they will face in their careers.
      ''',
    },
    {
      'title': 'Affiliation',
      'color': Colors.green,
      'content': 'Our affiliations and recognitions are listed here...',
    },
    {
      'title': 'News and Events',
      'color': Colors.orange,
      'content': 'Stay updated with our latest news and events here...',
    },
    {
      'title': 'Partners with Us',
      'color': Colors.purple,
      'content': 'Partner with Aptech for mutual growth here...',
    },
    {
      'title': 'Alumni',
      'color': Colors.blue,
      'content': 'Our proud alumni network is listed here...',
    },
    {
      'title': 'Placement',
      'color': Colors.teal,
      'content': 'Find us and our placement details here...',
    },
    {
      'title': 'Locations',
      'color': Color(0xFFFEBE10),
      'content': 'Find us and our placement details here...',
    },
  ];

  final Map<String, List<Map<String, String>>> details = {
    'Local Bodies': [
      {
        'title': 'Local Body 1',
        'content': 'Sindh Board of Technical Education (SBTE)\nAptechs HDSE-SBTE program is affiliated with SBTE.',
        'image': 'assets/images/SBTE-01.png',
      },
      {
        'title': 'Local Body 2',
        'content': 'Sindh Technical Education & Vocational Training Authority (STEVTA)\nAptech is registered with STEVTA.',
        'image': 'assets/images/STEVTA-02.png',
      },
    ],
    'International Universities': [
      {
        'title': 'International University 1',
        'content': 'Study Abroad & Degree Pathway\nAptech has collaborated with many education institutes and universities around the world for the benefit of our students.\nAptech enables students to gain an International degree via Credit Transfer Facility (CTF).',
        'image': 'assets/images/middle.png',
      },
      {
        'title': 'International University 2',
        'content': 'Study Abroad & Degree Pathway\nAptech has collaborated with many education institutes and universities around the world for the benefit of our students.\nAptech enables students to gain an International degree via Credit Transfer Facility (CTF).',
        'image': 'assets/images/middle.png',
      },
    ],
  };

  String? _selectedFeatureTitle;
  String? _selectedDetailCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white, // Set background color to white
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carousel Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
              ),
              items: imgList.map((item) =>
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )).toList(),
            ),
            // Title Carousel Slider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 60.0,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.4,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _selectedFeatureTitle = featureList[index]['title'];
                          if (_selectedFeatureTitle != 'Affiliation') {
                            _selectedDetailCategory = null;
                          }
                        });
                      },
                    ),
                    items: featureList.map((feature) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFeatureTitle = feature['title'];
                            if (_selectedFeatureTitle != 'Affiliation') {
                              _selectedDetailCategory = null;
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: feature['color'],
                          ),
                          child: Center(
                            child: Text(
                              feature['title'] ?? '', // Handle null title
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Display content for the selected feature
                  if (_selectedFeatureTitle != null)
                    if (_selectedFeatureTitle == 'Affiliation')
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedDetailCategory = 'Local Bodies';
                                    });
                                  },
                                  child: Text('Local Bodies'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedDetailCategory =
                                      'International Universities';
                                    });
                                  },
                                  child: Text('International Universities'),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedDetailCategory != null)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                // Adjust this based on the screen width
                                childAspectRatio: 1.5, // Adjust the ratio as needed
                              ),
                              itemCount: details[_selectedDetailCategory!]
                                  ?.length ?? 0,
                              itemBuilder: (context, index) {
                                final detail = details[_selectedDetailCategory!]![index];
                                return Card(
                                  elevation: 4.0,
                                  margin: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 150.0,
                                        ),
                                        child: Image.asset(
                                          detail['image'] ?? '',
                                          // Handle null image
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            detail['content'] ?? '',
                                            // Handle null content
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 4.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 150.0,
                                ),
                                child: Image.asset(
                                  featureList.firstWhere(
                                        (feature) =>
                                    feature['title'] == _selectedFeatureTitle,
                                    orElse: () => {'image': ''},
                                  )['image'] ?? '', // Handle null image
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    featureList.firstWhere(
                                          (feature) =>
                                      feature['title'] == _selectedFeatureTitle,
                                      orElse: () => {'content': ''},
                                    )['content'] ?? '', // Handle null content
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

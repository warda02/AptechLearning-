import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/student_service.dart';

class MyExamPage extends StatefulWidget {
  @override
  _MyExamPageState createState() => _MyExamPageState();
}

class _MyExamPageState extends State<MyExamPage> {
  final StudentService _studentService = StudentService();
  bool isLoading = true;
  List<Map<String, dynamic>>? examsData;

  @override
  void initState() {
    super.initState();
    _fetchExamsData();
  }

  Future<void> _fetchExamsData() async {
    try {
      List<Map<String, dynamic>> data = await _studentService.fetchExamsData();
      setState(() {
        examsData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching exams data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams'),
      ),
      body: Column(
        children: [
          // Banner Section
          Container(
            width: double.infinity,
            height: 200, // Adjust height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/exambanner.jpg'), // Use AssetImage for local assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16), // Space between banner and note

          // Note Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Here is the latest update on exams. Check the details below.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(height: 16), // Space between note and exam list

          // Exam List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : examsData != null && examsData!.isNotEmpty
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16.0, // Space between columns
                mainAxisSpacing: 16.0, // Space between rows
                childAspectRatio: 0.75, // Adjust the aspect ratio to better fit the content
              ),
              itemCount: examsData!.length,
              itemBuilder: (context, index) {
                final record = examsData![index];
                final imageUrl = record['imageUrl'] ?? '';
                final title = record['title'] ?? 'No Title';
                final date = record['date'] ?? 'No Date';
                final examType = record['examType'] ?? 'No Type';
                final time = record['time'] ?? 'No Time';

                return Card(
                  elevation: 5,
                  color: Colors.white, // Set card background color to white
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageUrl.isNotEmpty
                          ? Container(
                        width: double.infinity,
                        height: 120, // Fixed height for image section
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Container(
                        width: double.infinity,
                        height: 120, // Fixed height for placeholder
                        color: Colors.grey,
                        child: Icon(Icons.image, size: 40, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Date: $date\nType: $examType\nTime: $time',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
                : Center(child: Text('No Exams Data Available')),
          ),

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/student_service.dart';

class ViewExams extends StatefulWidget {
  @override
  _ViewExamsState createState() => _ViewExamsState();
}

class _ViewExamsState extends State<ViewExams> {
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
        backgroundColor:Color(0xFFFEBE10) ,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : examsData != null && examsData!.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16), // Space between AppBar and heading
          Container(
            width: double.infinity,
          
            padding: EdgeInsets.all(16.0),
            child: Text(
              'This is a modular exam schedule for all batches.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: examsData!.length,
              itemBuilder: (context, index) {
                final record = examsData![index];
                final title = record['title'] ?? 'No Title';
                final date = record['date'] ?? 'No Date';
                final examType = record['examType'] ?? 'No Type';
                final time = record['time'] ?? 'No Time';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),

                  ),
                  color: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: $date',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Type: $examType',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Time: $time',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
          : Center(child: Text('No Exams Data Available')),
    );
  }
}

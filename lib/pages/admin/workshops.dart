import 'package:flutter/material.dart';
import '../../services/student_service.dart';
import '../../models/workshop.dart';

class ViewWorkshops extends StatefulWidget {
  @override
  _ViewWorkshopsState createState() => _ViewWorkshopsState();
}

class _ViewWorkshopsState extends State<ViewWorkshops> {
  final StudentService _studentService = StudentService();
  bool isLoading = true;
  List<Workshops>? workshopsData;

  @override
  void initState() {
    super.initState();
    _fetchWorkshopData();
  }

  Future<void> _fetchWorkshopData() async {
    try {
      List<Workshops> data = await _studentService.fetchWorkshopData();
      setState(() {
        workshopsData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching workshop data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workshops'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : workshopsData != null && workshopsData!.isNotEmpty
          ? ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: workshopsData!.length,
        itemBuilder: (context, index) {
          final workshop = workshopsData![index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: workshop.imageUrl.isNotEmpty
                        ? Image.network(
                      workshop.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workshop.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Faculty: ${workshop.faculty}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Date: ${workshop.date}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          workshop.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(child: Text('No Workshop Data Available')),
    );
  }
}

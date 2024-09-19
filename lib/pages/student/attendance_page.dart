import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/Attendance.dart';

class AttendancePage extends StatefulWidget {
  final String studentId;

  AttendancePage({required this.studentId});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Future<List<Attendance>> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _attendanceFuture = fetchAttendance();
  }

  Future<List<Attendance >> fetchAttendance () async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc('O1FsNm0PkQU5i1pQrj2q9yUOknA2') // Replace with actual student ID
          .collection('attendance')
          .get();

      List<Attendance > summaries = snapshot.docs.map((doc) {
        return Attendance .fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return summaries;
    } catch (e) {
      print('Error fetching attendance summary: $e');
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300.0), // Custom height for app bar
        child: AppBar(
          title: Text('Attendance Summary'),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset(
            'assets/images/attendbanner.jpg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
              SizedBox(height: 10.0), // Space between image and heading
              Text(
                "Your Semester Attendance",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,


                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/back_arrow.svg',
              color: Colors.white,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),


      body: FutureBuilder<List<Attendance>>(
        future: _attendanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No attendance summaries found.'));
          }

          List<Attendance> summaries = snapshot.data!;

          return ListView.builder(
            itemCount: summaries.length,
            itemBuilder: (context, index) {
              Attendance summary = summaries[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Color(0xFFFEBE10), // Set card background color
                child: ListTile(
                  title: Text(
                    summary.semester,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Attendance Details - ${summary.semester}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailText('Total Sessions: ${summary.totalSessions}'),
                              _buildDetailText('Total Sessions Attended: ${summary.totalSessionsAttended}'),
                              _buildDetailText('Attendance: ${summary.attendance.toStringAsFixed(2)}%'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

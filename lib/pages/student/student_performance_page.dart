import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/student_performance.dart';
import '../../services/student_service.dart';
import '../../theme/colors.dart';

class StudentPerformancePage extends StatefulWidget {
  @override
  _StudentPerformancePageState createState() => _StudentPerformancePageState();
}

class _StudentPerformancePageState extends State<StudentPerformancePage> {
  final StudentService _studentService = StudentService();
  bool isLoading = true;
  List<PerformanceRecord>? performanceData;
  List<String> courseNames = [];
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    _fetchPerformanceData();
  }

  Future<void> _fetchPerformanceData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      String studentId = user.uid;

      List<PerformanceRecord> data =
      await _studentService.fetchPerformanceRecordsData(studentId);

      Set<String> courseSet = data.map((record) => record.courseName).toSet();
      courseNames = courseSet.toList();

      setState(() {
        performanceData = data;
        selectedCourse = courseNames.isNotEmpty ? courseNames[0] : null;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching performance data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<PerformanceRecord> _filterPerformanceData(String course) {
    return performanceData
        ?.where((record) => record.courseName == course)
        .toList() ??
        [];
  }

  void _showDetailsDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(child: content),
          actions: <Widget>[
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/ban.jpg',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
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
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: selectedCourse,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                filled: true,
                fillColor: Color(0xFFFEBE10),
                hintText: 'Select Your Semester',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
              dropdownColor: Color(0xFFFEBE10),
              iconEnabledColor: Colors.black,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCourse = newValue!;
                });
              },
              items: courseNames
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildListItem(
                  'Attendance and Punctuality',
                  'assets/images/attendance.svg',
                  _buildAttendanceAndPunctualityContent(),
                ),
                _buildListItem(
                  'Marks',
                  'assets/images/marks.svg',
                  _buildMarksContent(),
                ),
                _buildListItem(
                  'Teacher\'s Comments',
                  'assets/images/tcomment.svg',
                  _buildTeachersCommentsContent(),
                ),
                _buildListItem(
                  'Performance Summary',
                  'assets/images/performance.svg',
                  _buildPerformanceSummaryContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String iconPath, Widget content) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: SvgPicture.asset(
          iconPath,
          height: 30,
          width: 30,
          color: Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: SvgPicture.asset(
          'assets/icons/forward_arrow.svg',
          height: 20,
          width: 20,
          color: Colors.black54,
        ),
        onTap: () {
          _showDetailsDialog(title, content);
        },
      ),
    );
  }

  Widget _buildAttendanceAndPunctualityContent() {
    var data = _filterPerformanceData(selectedCourse!);
    if (data.isNotEmpty) {
      PerformanceRecord record = data.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailText('Attendance: ${record.attendancePercentage}%'),
          _buildDetailText('Punctuality: ${record.punctuality}'),
        ],
      );
    } else {
      return Text('No data available.');
    }
  }

  Widget _buildMarksContent() {
    var data = _filterPerformanceData(selectedCourse!);
    if (data.isNotEmpty) {
      PerformanceRecord record = data.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailText('Course Name: ${record.courseName}'),
          _buildDetailText('Module Name: ${record.moduleName}'),
          _buildDetailText('Exam Type: ${record.examType}'),
          _buildDetailText('Marks Obtained: ${record.marksObtained}'),
          _buildDetailText('Total Marks: ${record.totalMarks}'),
          _buildDetailText('Weightage: ${record.weightage}'),
          _buildDetailText('GPA: ${record.gpa}'),
        ],
      );
    } else {
      return Text('No data available.');
    }
  }

  Widget _buildTeachersCommentsContent() {
    var data = _filterPerformanceData(selectedCourse!);
    if (data.isNotEmpty) {
      PerformanceRecord record = data.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailText('Class Behavior: ${record.classBehavior}'),
          _buildDetailText('Class Participation: ${record.classParticipation}'),
          _buildDetailText('Teacher Feedback: ${record.teacherFeedback}'),
        ],
      );
    } else {
      return Text('No data available.');
    }
  }

  Widget _buildPerformanceSummaryContent() {
    var data = _filterPerformanceData(selectedCourse!);
    if (data.isNotEmpty) {
      PerformanceRecord record = data.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailText('${record.performanceSummary}'),
        ],
      );
    } else {
      return Text('No data available.');
    }
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
      ),
    );
  }
}

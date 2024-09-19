import 'package:flutter/material.dart';
import 'package:aptech_clifton/models/Attendance.dart';
import 'faculty_services/FacultyService.dart';

class ManageAttendancePage extends StatefulWidget {
  @override
  _ManageAttendancePageState createState() => _ManageAttendancePageState();
}

class _ManageAttendancePageState extends State<ManageAttendancePage> {
  final FacultyService _facultyService = FacultyService();
  final String studentId = 'O1FsNm0PkQU5i1pQrj2q9yUOknA2'; // Replace with actual student ID
  late Future<List<Attendance>> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _attendanceFuture = _fetchAttendanceData();
  }

  Future<List<Attendance>> _fetchAttendanceData() async {
    try {
      final data = await _facultyService.getStudentSubcollectionData(studentId, 'attendance');
      return data.map((item) => Attendance(
        id: item['id'] ?? '',
        semester: item['semester'] ?? '',
        totalSessions: int.parse(item['totalSessions'] ?? '0'),
        totalSessionsAttended: int.parse(item['Total Sessions Attended'] ?? '0'),
        attendance: double.parse(item['Attendance'] ?? '0.0'),
      )).toList();
    } catch (e) {
      print('Error fetching attendance data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Attendance'),
      ),
      body: Column(
        children: [
          _buildAddAttendanceButton(context),
          Expanded(
            child: FutureBuilder<List<Attendance>>(
              future: _attendanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No attendance records found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final attendance = snapshot.data![index];
                    return _buildAttendanceCard(attendance);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(Attendance attendance) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(attendance.semester),
        subtitle: Text(
          'Total Sessions: ${attendance.totalSessions}\n'
              'Total Sessions Attended: ${attendance.totalSessionsAttended}\n'
              'Attendance: ${attendance.attendance.toStringAsFixed(2)}%',
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteAttendance(attendance.id),
        ),
      ),
    );
  }

  Widget _buildAddAttendanceButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () => _showAddAttendanceDialog(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.orange,  // Orange button color
        ),
        child: Text('Add Attendance'),
      ),
    );
  }

  void _deleteAttendance(String attendanceId) {
    _facultyService.deleteStudentSubcollectionData(studentId, 'attendance', attendanceId).then((_) {
      setState(() {
        _attendanceFuture = _fetchAttendanceData();
      });
    }).catchError((error) {
      print('Error deleting attendance: $error');
    });
  }

  void _showAddAttendanceDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String semester = '', totalSessions = '', totalSessionsAttended = '', attendance = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Attendance'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  labelText: 'Semester',
                  onSaved: (value) => semester = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a semester' : null,
                ),
                _buildTextField(
                  labelText: 'Total Sessions',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => totalSessions = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter total sessions' : null,
                ),
                _buildTextField(
                  labelText: 'Total Sessions Attended',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => totalSessionsAttended = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter total sessions attended' : null,
                ),
                _buildTextField(
                  labelText: 'Attendance (%)',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) => attendance = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter attendance percentage' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  _addAttendance(semester, totalSessions, totalSessionsAttended, attendance);
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.orange)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  TextFormField _buildTextField({
    required String labelText,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  void _addAttendance(String semester, String totalSessions, String totalSessionsAttended, String attendance) {
    _facultyService.addStudentSubcollectionData(studentId, 'attendance', {
      'semester': semester,
      'totalSessions': totalSessions,
      'Total Sessions Attended': totalSessionsAttended,
      'Attendance': attendance,
    }).then((_) {
      Navigator.of(context).pop();
      setState(() {
        _attendanceFuture = _fetchAttendanceData();
      });
    }).catchError((error) {
      print('Error adding attendance: $error');
    });
  }
}

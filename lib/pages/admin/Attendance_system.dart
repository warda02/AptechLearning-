import 'package:flutter/material.dart';

class AttendanceSystem extends StatefulWidget {
  @override
  _AttendanceSystemState createState() => _AttendanceSystemState();
}

class _AttendanceSystemState extends State<AttendanceSystem> {
  // Static data for batches, timings, and students
  final Map<String, Map<String, Map<String, List<String>>>> batches = {
    'Batch 08E-2022': {
      'TTS': {
        '3-5 PM': ['Ahmed', 'Aisha', 'Fatima', 'Hassan', 'Mariam'],
        '5-7 PM': ['Bilal', 'Zainab', 'Yousuf', 'Sara', 'Omar'],
      },
    },
    'Batch 06B-2024': {
      'MWF': {
        '5-7 PM': ['Rania', 'Ali', 'Nadia', 'Hamza', 'Sana'],
        '7-9 PM': ['Usman', 'Hiba', 'Zara', 'Tariq', 'Ibrahim'],
      },
    },
  };

  String? selectedBatch;
  String? selectedDay;
  String? selectedTiming;
  Map<String, bool> attendance = {};
  DateTime selectedDate = DateTime.now();

  // Define a consistent color scheme
  final Color primaryColor = Colors.orange;
  final Color myColor = Color(0xFFFEBE10);
  final Color backgroundColor = Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Sessions Attendance'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Selection Cards
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Batch and Day Selection
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Batch',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.group),
                              ),
                              value: selectedBatch,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedBatch = newValue;
                                  selectedDay = null;
                                  selectedTiming = null;
                                  attendance.clear();
                                });
                              },
                              items: batches.keys.map((String batch) {
                                return DropdownMenuItem<String>(
                                  value: batch,
                                  child: Text(batch),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Day',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              value: selectedDay,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDay = newValue;
                                  selectedTiming = null;
                                  attendance.clear();
                                });
                              },
                              items: selectedBatch != null
                                  ? batches[selectedBatch]!.keys.map((String day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(day),
                                );
                              }).toList()
                                  : [],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Timing and Date Selection
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Timing',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              value: selectedTiming,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTiming = newValue;
                                  attendance.clear();
                                  if (selectedBatch != null &&
                                      selectedDay != null &&
                                      selectedTiming != null) {
                                    batches[selectedBatch]![selectedDay]![selectedTiming]?.forEach((student) {
                                      attendance[student] = false;
                                    });
                                  }
                                });
                              },
                              items: (selectedBatch != null && selectedDay != null)
                                  ? batches[selectedBatch]![selectedDay]!.keys.map((String timing) {
                                return DropdownMenuItem<String>(
                                  value: timing,
                                  child: Text(timing),
                                );
                              }).toList()
                                  : [],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectDate,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Select Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: Icon(Icons.date_range),
                                  ),
                                  controller: TextEditingController(
                                    text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Student Attendance List
              if (selectedTiming != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Students in $selectedBatch (${selectedDay} - $selectedTiming)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: batches[selectedBatch]![selectedDay]![selectedTiming]?.length ?? 0,
                    itemBuilder: (context, index) {
                      String student = batches[selectedBatch]![selectedDay]![selectedTiming]![index];
                      return ListTile(
                        title: Text(
                          student,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Present Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: attendance[student] == true,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      attendance[student] = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                                Text(
                                  'Present',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            // Absent Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: attendance[student] == false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        attendance[student] = false;
                                      }
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                                Text(
                                  'Absent',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 20),
              // Update Attendance Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedTiming != null ? _updateAttendance : null,
                  child: Text(
                    'Update Attendance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: primaryColor, padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Date Picker Function
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: primaryColor,
            hintColor: myColor,
            colorScheme: ColorScheme.light(primary: primaryColor),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Update Attendance Function
  void _updateAttendance() {
    // Gather present and absent students
    List<String> presentStudents = attendance.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
    List<String> absentStudents = attendance.entries
        .where((entry) => entry.value == false)
        .map((entry) => entry.key)
        .toList();

    // For now, just show a Snackbar with the results
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Attendance Updated:\nPresent: ${presentStudents.length}\nAbsent: ${absentStudents.length}',
        ),
      ),
    );
  }
}

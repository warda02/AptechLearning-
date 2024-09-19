import 'package:aptech_clifton/theme/colors.dart';
import 'package:flutter/material.dart';

class BatchSystem extends StatefulWidget {
  @override
  _BatchSystemState createState() => _BatchSystemState();
}

class _BatchSystemState extends State<BatchSystem> {
  // Static data for batches, timings, and students
  final Map<String, Map<String, Map<String, List<String>>>> batches = {
    'Batch 08E-2022': {
      'MWF': {
        '3-5 PM': ['Ahmed', 'Aisha', 'Fatima', 'Hassan', 'Mariam'],
      },
    },
    'Batch 06B-2024': {
      'TTS': {
        '5-7 PM': ['Bilal', 'Zainab', 'Yousuf', 'Sara', 'Omar'],
      },
    },
    'Batch 07A-2023': {
      'MWF': {
        '7-9 PM': ['Usman', 'Hiba', 'Zara', 'Tariq', 'Ibrahim'],
      },
    },
  };

  String? selectedBatch;
  String? selectedDay;
  String? selectedTiming;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Batches and Students'),
        backgroundColor: Color(0xFFFEBE10) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting a batch
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Batch',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: selectedBatch,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBatch = newValue;
                  selectedDay = null;
                  selectedTiming = null;
                });
              },
              items: batches.keys.map((String batch) {
                return DropdownMenuItem<String>(
                  value: batch,
                  child: Text(batch),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (selectedBatch != null) ...[
              // Show Days for the selected batch
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Day',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue;
                    selectedTiming = null;
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
              SizedBox(height: 16),
              // Show Timings for the selected day
              if (selectedDay != null)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Timing',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: selectedTiming,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTiming = newValue;
                    });
                  },
                  items: selectedBatch != null && selectedDay != null
                      ? batches[selectedBatch]![selectedDay]!.keys.map((String timing) {
                    return DropdownMenuItem<String>(
                      value: timing,
                      child: Text(timing),
                    );
                  }).toList()
                      : [],
                ),
              SizedBox(height: 16),
              // Show Students for the selected timing
              if (selectedTiming != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: batches[selectedBatch]![selectedDay]![selectedTiming]!.length,
                    itemBuilder: (context, index) {
                      String student = batches[selectedBatch]![selectedDay]![selectedTiming]![index];
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(student),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: BatchSystem(),
  debugShowCheckedModeBanner: false,
));

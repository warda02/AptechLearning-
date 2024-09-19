import 'package:flutter/material.dart';
import 'package:aptech_clifton/services/student_service.dart';
import 'PaymentForm.dart';
import '../../models/FeesStatus.dart';

class FeesStatusPage extends StatefulWidget {
  @override
  _FeesStatusPageState createState() => _FeesStatusPageState();
}

class _FeesStatusPageState extends State<FeesStatusPage> {
  late Future<List<FeesStatus>> feesStatusData;
  final StudentService _feesStatusService = StudentService();
  final String studentId = 'O1FsNm0PkQU5i1pQrj2q9yUOknA2'; // Replace with actual student ID
  String selectedMonth = 'September'; // Default selected month

  @override
  void initState() {
    super.initState();
    feesStatusData = _fetchFeesStatusDataForMonth(selectedMonth);
  }

  Future<List<FeesStatus>> _fetchFeesStatusDataForMonth(String month) async {
    // Fetch data filtered by month
    List<FeesStatus> allFeesStatus = await _feesStatusService.fetchFeesStatusData(studentId);
    return allFeesStatus.where((fee) => fee.month == month).toList();
  }

  void _showPaymentForm(BuildContext context, FeesStatus feeData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pay Fees for ${feeData.month}'),
          content: PaymentForm(feeData: feeData),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onMonthChanged(String? newMonth) {
    if (newMonth != null) {
      setState(() {
        selectedMonth = newMonth;
        feesStatusData = _fetchFeesStatusDataForMonth(selectedMonth);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          // Banner Image
          Container(
            width: double.infinity,
            child: Image.asset(
              'assets/images/feebaner.webp', // Replace with your banner image asset
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          // Note Below Banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Pay your fees on time to avoid any penalties.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Change color as needed
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Dropdown for Selecting Month
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: selectedMonth,
                onChanged: _onMonthChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFEBE10), // Dropdown background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: <String>[
                  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          // Fees Status List
          Expanded(
            child: FutureBuilder<List<FeesStatus>>(
              future: feesStatusData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No fees status data found.'));
                } else {
                  final List<FeesStatus> feesStatusList = snapshot.data!;
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: feesStatusList.map((feeData) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.white, // Card background color
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feeData.month,
                                style: Theme.of(context).textTheme.headlineMedium, // Use headlineMedium
                              ),
                              SizedBox(height: 8.0),
                              Text('Amount: ${feeData.amount}', style: TextStyle(fontSize: 16)),
                              Text('Amount After Due Date: ${feeData.amountAfterDueDate}', style: TextStyle(fontSize: 16)),
                              Text('Date: ${feeData.date}', style: TextStyle(fontSize: 16)),
                              Text('Due Date: ${feeData.dueDate}', style: TextStyle(fontSize: 16)),
                              SizedBox(height: 8.0),
                              feeData.status != 'Paid'
                                  ? ElevatedButton(
                                onPressed: () => _showPaymentForm(context, feeData),
                                child: Text('Pay Now'),
                              )
                                  : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8.0),
                                  Text('Fees Paid', style: TextStyle(color: Colors.green)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

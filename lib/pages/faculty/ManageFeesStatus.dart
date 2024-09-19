import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'faculty_services/FacultyService.dart'; // Import your Firebase service class

class ManageFeesStatus extends StatefulWidget {
  @override
  _ManageFeesStatusState createState() => _ManageFeesStatusState();
}

class _ManageFeesStatusState extends State<ManageFeesStatus> {
  final FacultyService _facultyService = FacultyService();
  final String studentId = 'O1FsNm0PkQU5i1pQrj2q9yUOknA2'; // Replace with actual student ID
  late Future<List<Map<String, dynamic>>> _feesStatusFuture;

  @override
  void initState() {
    super.initState();
    _feesStatusFuture = _facultyService.getStudentSubcollectionData(studentId, 'feesStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Fees Status'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddFeesDialog(context);
              },
              child: Text('Add Fees Status'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _feesStatusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No fees status found.'));
                }

                List<Map<String, dynamic>> feesStatusList = snapshot.data!;

                return ListView.builder(
                  itemCount: feesStatusList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> fees = feesStatusList[index];
                    String feesId = fees['id'] ?? '';
                    String month = fees['month'] ?? 'No Month';
                    double amount = fees['amount'] ?? 0.0;
                    String status = fees['status'] ?? 'Pending';

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              month,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Amount: $amount'),
                            Text('Status: $status'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showEditFeesDialog(context, feesId, month, amount, status);
                                  },
                                  child: Text('Edit'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.orange,
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    _deleteFeesStatus(feesId);
                                  },
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFeesStatus(String feesId) async {
    try {
      await _facultyService.deleteStudentSubcollectionData(studentId, 'feesStatus', feesId);
      setState(() {
        _feesStatusFuture = _facultyService.getStudentSubcollectionData(studentId, 'feesStatus');
      });
    } catch (error) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete fees status: $error')));
    }
  }

  void _showAddFeesDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String month = '';
    double amount = 0.0;
    String status = 'Pending';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Fees Status'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Month'),
                  onSaved: (value) {
                    month = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the month';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    amount = double.tryParse(value ?? '0') ?? 0.0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Status'),
                  onChanged: (value) {
                    status = value ?? 'Pending';
                  },
                  items: ['Pending', 'Paid'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addFeesStatus(month, amount, status);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addFeesStatus(String month, double amount, String status) async {
    try {
      await _facultyService.addStudentSubcollectionData(
        studentId,
        'feesStatus',
        {
          'month': month,
          'amount': amount,
          'status': status,
          'created_at': FieldValue.serverTimestamp(),
        },
      );
      setState(() {
        _feesStatusFuture = _facultyService.getStudentSubcollectionData(studentId, 'feesStatus');
      });
    } catch (error) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add fees status: $error')));
    }
  }

  void _showEditFeesDialog(BuildContext context, String feesId, String currentMonth, double currentAmount, String currentStatus) {
    final _formKey = GlobalKey<FormState>();
    String month = currentMonth;
    double amount = currentAmount;
    String status = currentStatus;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Fees Status'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: currentMonth,
                  decoration: InputDecoration(labelText: 'Month'),
                  onSaved: (value) {
                    month = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the month';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: currentAmount.toString(),
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    amount = double.tryParse(value ?? '0') ?? 0.0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Status'),
                  onChanged: (value) {
                    status = value ?? 'Pending';
                  },
                  items: ['Pending', 'Paid'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _updateFeesStatus(feesId, month, amount, status);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateFeesStatus(String feesId, String month, double amount, String status) async {
    try {
      await _facultyService.updateStudentSubcollectionData(
        studentId,
        'feesStatus',
        feesId,
        {
          'month': month,
          'amount': amount,
          'status': status,
          'updated_at': FieldValue.serverTimestamp(),
        },
      );
      setState(() {
        _feesStatusFuture = _facultyService.getStudentSubcollectionData(studentId, 'feesStatus');
      });
    } catch (error) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update fees status: $error')));
    }
  }
}

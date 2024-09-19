

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/FeesStatus.dart';

class AddFeesChalan extends StatefulWidget {
  @override
  _AddFeesChalanState createState() => _AddFeesChalanState();
}

class _AddFeesChalanState extends State<AddFeesChalan> {
  final _formKey = GlobalKey<FormState>();
  String month = '';
  double amount = 0.0;
  double amountAfterDueDate = 0.0;
  String dueDate = '';
  String status = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Fees Chalan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Month'),
                onSaved: (value) => month = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter month' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) => amount = double.tryParse(value ?? '0') ?? 0.0,
                validator: (value) => value!.isEmpty ? 'Please enter amount' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount After Due Date'),
                keyboardType: TextInputType.number,
                onSaved: (value) => amountAfterDueDate = double.tryParse(value ?? '0') ?? 0.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Due Date'),
                onSaved: (value) => dueDate = value ?? '',
              ),
              DropdownButtonFormField<String>(
                value: status,
                onChanged: (value) => status = value ?? 'Pending',
                items: ['Pending', 'Paid'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addFeesChalanForAllStudents();
                  }
                },
                child: Text('Add Chalan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addFeesChalanForAllStudents() async {
    try {
      final studentsSnapshot = await FirebaseFirestore.instance.collection('students').get();
      for (var student in studentsSnapshot.docs) {
        final studentId = student.id;
        FeesStatus feesStatus = FeesStatus(
          id: '', // Firestore will auto-generate
          month: month,
          studentId: studentId,
          amount: amount,
          amountAfterDueDate: amountAfterDueDate,
          dueDate: dueDate,
          status: status,
          date: DateTime.now().toString(),
        );
        await addFeesStatus(studentId, feesStatus);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fees chalan added for all students')));
    } catch (e) {
      print('Error adding fees chalan: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding fees chalan')));
    }
  }

  Future<void> addFeesStatus(String studentId, FeesStatus feesStatus) async {
    final feesCollection = FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('feesStatus');

    await feesCollection.add(feesStatus.toMap());
  }
}

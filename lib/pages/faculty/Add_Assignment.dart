import 'package:flutter/material.dart';
import 'faculty_services/StudentManagementService.dart';

class AddAssignmentScreen extends StatefulWidget {
  final String studentId;

  AddAssignmentScreen({required this.studentId});

  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();

  final StudentManagementService service = StudentManagementService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await service.addAssignment(
                      widget.studentId,
                      {
                        'title': _title,
                        'description': _description,
                        'dueDate': _dueDate,
                      },
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Assignment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

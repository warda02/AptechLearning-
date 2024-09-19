import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationFormPage extends StatefulWidget {
  @override
  _ApplicationFormPageState createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _applicationType = 'Leave Request'; // Default type

  Future<void> _submitApplication() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance.collection('applications').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'applicationType': _applicationType,
          'details': _detailsController.text,
          'submittedAt': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application submitted successfully')),
        );
        // Clear form fields
        _formKey.currentState?.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting application: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _applicationType,
                onChanged: (newValue) {
                  setState(() {
                    _applicationType = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(value: 'Leave Request', child: Text('Leave Request')),
                  DropdownMenuItem(value: 'Course Upgrade', child: Text('Course Upgrade')),
                  DropdownMenuItem(value: 'Class Time Change', child: Text('Class Time Change')),
                ],
                decoration: InputDecoration(labelText: 'Application Type'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value?.isEmpty ?? true ? 'Phone number is required' : null,
              ),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Details'),
                maxLines: 4,
                validator: (value) => value?.isEmpty ?? true ? 'Details are required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitApplication,
                child: Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

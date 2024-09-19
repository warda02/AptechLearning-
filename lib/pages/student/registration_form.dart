import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aptech_clifton/models/course.dart';

class RegistrationFormPage extends StatefulWidget {
  final shortCourses course;

  RegistrationFormPage({required this.course});

  @override
  _RegistrationFormPageState createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String contact = '';
  String education = '';
  String city = '';
  String location = '';

  String feedback = '';
  String selectedDays = '';
  String selectedTime = '';



  List<String> cities = [
    'Karachi',

  ];

  List<String> karachiAreas = [
    'Gulshan-e-Iqbal',
    'Clifton',
    'Defense',
    'Saddar',
    'North Nazimabad'
  ];

  List<String> days = [
    'Saturday, Tuesday, Thursday',
    'Monday, Wednesday, Friday'
  ];

  List<String> times = [
    '9 AM to 1 PM',
    '3 PM to 5 PM',
    '5 PM to 7 PM',
    '7 PM to 9 PM'
  ];

  // Reference to Firestore collection
  final CollectionReference registrations = FirebaseFirestore.instance.collection('registrations');

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await registrations.add({
          'name': name,
          'email': email,
          'contact': contact,

          'education': education,
          'city': city,
          'location': location,

          'feedback': feedback,
          'days': selectedDays,
          'time': selectedTime,
          'courseId': widget.course.id, // Include course ID for reference
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Successful'),
              content: Text('Thank you for registering. We will contact you soon for confirmation.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Navigate back to previous page
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text('An error occurred while saving your registration. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name *'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email *'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact *'),
                onChanged: (value) {
                  setState(() {
                    contact = value;
                  });
                },
                validator: (value) => value!.isEmpty ? 'Please enter your contact number' : null,
              ),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Your Education *'),
                items: [
                  'Matriculation',
                  'Intermediate',
                  'Graduation',
                  'Masters',
                  'PhD'
                ].map((education) {
                  return DropdownMenuItem(
                    value: education,
                    child: Text(education),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    education = value!;
                  });
                },
                validator: (value) => value == null ? 'Please select your education' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select City *'),
                items: cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    city = value!;
                    // Update location areas based on city
                    location = ''; // Reset location
                  });
                },
                validator: (value) => value == null ? 'Please select a city' : null,
              ),
              if (city == 'Karachi') ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select Nearest Location *'),
                  items: karachiAreas.map((area) {
                    return DropdownMenuItem(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      location = value!;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a location' : null,
                ),
              ],

              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Days Available *'),
                items: days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDays = value!;
                  });
                },
                validator: (value) => value == null ? 'Please select available days' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Time Available *'),
                items: times.map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTime = value!;
                  });
                },
                validator: (value) => value == null ? 'Please select available time' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

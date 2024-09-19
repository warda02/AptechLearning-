import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'faculty_services/FacultyService.dart';

class ManageWorkshopsPage extends StatefulWidget {
  @override
  _ManageWorkshopsPageState createState() => _ManageWorkshopsPageState();
}

class _ManageWorkshopsPageState extends State<ManageWorkshopsPage> {
  final FacultyService _facultyService = FacultyService();
  late Future<List<Map<String, dynamic>>> _workshopsFuture;

  @override
  void initState() {
    super.initState();
    _workshopsFuture = _facultyService.getAllWorkshops(); // Fetch all workshops
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Workshops'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddWorkshopDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set button color to orange
              ),
              child: Text('Add Workshop'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _workshopsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Workshops found.'));
                }

                List<Map<String, dynamic>> workshops = snapshot.data!;

                return ListView.builder(
                  itemCount: workshops.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> workshop = workshops[index];
                    String workshopId = workshop['id'] ?? '';
                    String title = workshop['title'] ?? 'No Title';
                    String faculty = workshop['faculty'] ?? 'No Faculty';
                    String date = workshop['date'] ?? 'No Date';
                    String description = workshop['description'] ?? 'No Description';
                    String imageUrl = workshop['imageUrl'] ?? ''; // Handle imageUrl

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.white, // Set card background color to white
                      child: ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.image, size: 50),
                        title: Text(title),
                        subtitle: Text(
                          'Date: $date\n'
                              'Faculty: $faculty\n'
                              'Description: $description\n',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditWorkshopDialog(context, workshop);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _facultyService.deleteWorkshop(workshopId);
                                setState(() {
                                  _workshopsFuture = _facultyService.getAllWorkshops(); // Refresh the list
                                });
                              },
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

  void _showAddWorkshopDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String faculty = '';
    String date = '';
    String imageUrl = ''; // Added imageUrl

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Workshop'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    title = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    description = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Faculty'),
                  onSaved: (value) {
                    faculty = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter faculty name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
                  onSaved: (value) {
                    date = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'), // Added imageUrl field
                  onSaved: (value) {
                    imageUrl = value ?? '';
                  },
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
                  _facultyService.addWorkshop({
                    'title': title,
                    'description': description,
                    'faculty': faculty,
                    'date': date,
                    'imageUrl': imageUrl, // Add imageUrl to the data
                  });
                  setState(() {
                    _workshopsFuture = _facultyService.getAllWorkshops(); // Refresh the list
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set button color to orange
              ),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditWorkshopDialog(BuildContext context, Map<String, dynamic> workshop) {
    final _formKey = GlobalKey<FormState>();
    String title = workshop['title'] ?? '';
    String description = workshop['description'] ?? '';
    String faculty = workshop['faculty'] ?? '';
    String date = workshop['date'] ?? '';
    String imageUrl = workshop['imageUrl'] ?? ''; // Added imageUrl

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Workshop'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: title,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    title = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    description = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: faculty,
                  decoration: InputDecoration(labelText: 'Faculty'),
                  onSaved: (value) {
                    faculty = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter faculty name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: date,
                  decoration: InputDecoration(labelText: 'Date'),
                  onSaved: (value) {
                    date = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: imageUrl,
                  decoration: InputDecoration(labelText: 'Image URL'), // Added imageUrl field
                  onSaved: (value) {
                    imageUrl = value ?? '';
                  },
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
                  _facultyService.updateWorkshop(workshop['id'], {
                    'title': title,
                    'description': description,
                    'faculty': faculty,
                    'date': date,
                    'imageUrl': imageUrl, // Update imageUrl
                  });
                  setState(() {
                    _workshopsFuture = _facultyService.getAllWorkshops(); // Refresh the list
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set button color to orange
              ),
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManageCertificatePage extends StatefulWidget {
  @override
  _ManageCertificatePageState createState() => _ManageCertificatePageState();
}

class _ManageCertificatePageState extends State<ManageCertificatePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String studentId = 'O1FsNm0PkQU5i1pQrj2q9yUOknA2';
  late Future<List<Map<String, dynamic>>> _certificateFuture;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _certificateFuture = _getStudentCertificates(studentId, 'certificates');
  }

  Future<List<Map<String, dynamic>>> _getStudentCertificates(String studentId, String collectionName) async {
    try {
      final snapshot = await _firestore.collection('students').doc(studentId).collection(collectionName).get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<void> _addCertificate(String title, String issuedBy, String dateIssued, String imageUrl) async {
    try {
      await _firestore.collection('students').doc(studentId).collection('certificates').add({
        'title': title,
        'issuedBy': issuedBy,
        'dateIssued': dateIssued,
        'imageUrl': imageUrl,
        'created_at': FieldValue.serverTimestamp(),
      });
      setState(() {
        _certificateFuture = _getStudentCertificates(studentId, 'certificates');
      });
    } catch (e) {
      print("Error adding certificate: $e");
    }
  }

  Future<void> _deleteCertificate(String certificateId) async {
    try {
      await _firestore.collection('students').doc(studentId).collection('certificates').doc(certificateId).delete();
      setState(() {
        _certificateFuture = _getStudentCertificates(studentId, 'certificates');
      });
    } catch (e) {
      print("Error deleting certificate: $e");
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().toIso8601String();
      final ref = _storage.ref().child('certificates/$fileName');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  void _showAddCertificateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String issuedBy = '';
    String dateIssued = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Certificate', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
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
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Issued By',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      issuedBy = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the issuer';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date Issued',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      dateIssued = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the date issued';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select Image'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
                    ),
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.file(_selectedImage!, height: 100, width: 100),
                    ),
                ],
              ),
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  String imageUrl = '';
                  if (_selectedImage != null) {
                    imageUrl = await _uploadImage(_selectedImage!);
                  }
                  await _addCertificate(title, issuedBy, dateIssued, imageUrl);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Certificates'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddCertificateDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, // Text color
              ),
              child: Text('Add Certificate'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _certificateFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No certificates found.'));
                }

                List<Map<String, dynamic>> certificatesList = snapshot.data!;

                return ListView.builder(
                  itemCount: certificatesList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> certificate = certificatesList[index];
                    String certificateId = certificate['id'] ?? '';
                    String title = certificate['title'] ?? 'No Title';
                    String dateIssued = certificate['dateIssued'] ?? 'No date found';
                    String issuedBy = certificate['issuedBy'] ?? 'No issuer found';
                    String imageUrl = certificate['imageUrl'] ?? '';

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.white, // Card background color
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.image, size: 50),
                        title: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$issuedBy - $dateIssued',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteCertificate(certificateId);
                          },
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
}

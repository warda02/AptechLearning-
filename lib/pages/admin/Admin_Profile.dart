
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminProfilePage extends StatefulWidget {
  @override
  _FacultyProfilePageState createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<AdminProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _name;
  String? _phone;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('admin').doc(user.uid).get();
      setState(() {
        _name = doc['name'];
        _phone = doc['phone'];
        _imageUrl = doc['imageUrl'];
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        Map<String, dynamic> updatedData = {
          'name': _name,
          'phone': _phone,
        };

        if (_imageFile != null) {
          // Upload image to Firebase Storage and get the URL
          // (You need to implement `_uploadImage` function)
          String newImageUrl = await _uploadImage(_imageFile!);
          updatedData['imageUrl'] = newImageUrl;
        }

        await _firestore.collection('admin').doc(user.uid).update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  Future<String> _uploadImage(File image) async {
    // Implement your image upload logic here
    // This function should return the URL of the uploaded image
    return ''; // Placeholder
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Updated method
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile == null
                      ? (_imageUrl != null ? NetworkImage(_imageUrl!) : null)
                      : FileImage(_imageFile!) as ImageProvider,
                  child: _imageFile == null && _imageUrl == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phone = value,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _name;
  String? _phone;
  String? _email;
  String? _address;
  String? _imageUrl;
  File? _imageFile;

  bool _isLoading = true;  // Loading state

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('students').doc(user.uid).get();
        setState(() {
          _name = doc['name'];
          _phone = doc['phone'];
          _email = doc['email'];
          _address = doc['address'];
          _imageUrl = doc['imageUrl'];
          _isLoading = false;  // Data loaded
        });
      } catch (e) {
        print("Error fetching data: $e");
        setState(() {
          _isLoading = false;  // Stop loading if there's an error
        });
      }
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
          'email': _email,
          'address': _address,
        };

        if (_imageFile != null) {
          String newImageUrl = await _uploadImage(_imageFile!);
          updatedData['imageUrl'] = newImageUrl;
        }

        await _firestore.collection('students').doc(user.uid).update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('students_images').child('$fileName.jpg');

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())  // Loading indicator
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : (_imageUrl != null ? NetworkImage(_imageUrl!) : null),
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
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
                ),
                TextFormField(
                  initialValue: _address,
                  decoration: InputDecoration(labelText: 'Address'),
                  onSaved: (value) => _address = value,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter your address' : null,
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
      ),
    );
  }
}

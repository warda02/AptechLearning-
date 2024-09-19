import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // For HTTP requests
import '../../models/Certificates.dart';
import '../../services/student_service.dart';
import 'package:path_provider/path_provider.dart'; // For saving files locally
import 'dart:io'; // For file operations

class CertificatePage extends StatefulWidget {
  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final StudentService _studentService = StudentService();
  bool isLoading = true;
  List<Certificates>? certificateData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCertificateData();
  }

  Future<void> _fetchCertificateData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      String studentId = user.uid;

      List<Certificates> data =
      (await _studentService.fetchCertificatesData(studentId)).cast<Certificates>();

      setState(() {
        certificateData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching certificate data: $e');
      setState(() {
        errorMessage = 'Error fetching certificate data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _downloadCertificateImage(String imageUrl) async {
    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // Show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image downloaded to $filePath')),
      );
    } catch (e) {
      print('Error downloading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading image: $e')),
      );
    }
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300.0), // Custom height for app bar
        child: AppBar(
          title: SizedBox.shrink(), // Remove default title
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/certificate.jpeg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.0), // Space between image and heading
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Get Your Certificate\nDownload it from here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEBE10), // Heading color
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0), // Space before the bottom of the AppBar
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : certificateData == null || certificateData!.isEmpty
          ? Center(child: Text(errorMessage ?? 'No certificate data available'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: certificateData!.length,
        itemBuilder: (context, index) {
          final certificate = certificateData![index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            color: Colors.white, // Card background color
            child: Column(
              children: [
                // Certificate Image
                certificate.imageUrl.isNotEmpty
                    ? GestureDetector(
                  onTap: () {
                    _showFullScreenImage(certificate.imageUrl);
                  },
                  child: Image.network(
                    certificate.imageUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image, size: 150),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Title color
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Date Issued: ${certificate.dateIssued}'),
                      Text('Issued By: ${certificate.issuedBy}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _downloadCertificateImage(certificate.imageUrl);
                        },
                        child: Text('Download Certificate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFEBE10), // Button color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

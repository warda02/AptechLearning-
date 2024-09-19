import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aptech_clifton/models/sessions.dart';
import 'AdminService.dart';
import 'AdminService.dart';// Ensure this service is created

class ManageSession extends StatefulWidget {
  @override
  _ManageSessionState createState() => _ManageSessionState();
}

class _ManageSessionState extends State<ManageSession> {
  final AdminService _AdminService = AdminService();
  bool isLoading = true;
  List<Session>? sessionsData;

  @override
  void initState() {
    super.initState();
    _fetchSessionsData();
  }

  Future<void> _fetchSessionsData() async {
    try {
      List<Session> data = await _AdminService.fetchSessionsData();
      setState(() {
        sessionsData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching sessions data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSessionForm({Session? session}) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: session?.title ?? '');
        final dateController = TextEditingController(text: session?.date ?? '');
        final timeController = TextEditingController(text: session?.time ?? '');
        final facultyController = TextEditingController(text: session?.faculty ?? '');
        final zoomLinkController = TextEditingController(text: session?.zoomLink ?? '');

        return AlertDialog(
          title: Text(session == null ? 'Add Session' : 'Edit Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: facultyController,
                decoration: InputDecoration(labelText: 'Faculty'),
              ),
              TextField(
                controller: zoomLinkController,
                decoration: InputDecoration(labelText: 'Zoom Link'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (session == null) {
                  _addSession(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                    faculty: facultyController.text,
                    zoomLink: zoomLinkController.text,
                  );
                } else {
                  _updateSession(
                    id: session.id,
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                    faculty: facultyController.text,
                    zoomLink: zoomLinkController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(session == null ? 'Add' : 'Update'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFFFEBE10)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSession({
    required String title,
    required String date,
    required String time,
    required String faculty,
    required String zoomLink,
  }) async {
    try {
      await _AdminService.addSession(
        title: title,
        date: date,
        time: time,
        faculty: faculty,
        zoomLink: zoomLink,
      );
      _fetchSessionsData();
    } catch (e) {
      print('Error adding session: $e');
    }
  }

  Future<void> _updateSession({
    required String id,
    required String title,
    required String date,
    required String time,
    required String faculty,
    required String zoomLink,
  }) async {
    try {
      await _AdminService.updateSession(
        id: id,
        title: title,
        date: date,
        time: time,
        faculty: faculty,
        zoomLink: zoomLink,
      );
      _fetchSessionsData();
    } catch (e) {
      print('Error updating session: $e');
    }
  }

  Future<void> _deleteSession(String id) async {
    try {
      await _AdminService.deleteSession(id);
      _fetchSessionsData();
    } catch (e) {
      print('Error deleting session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Sessions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : sessionsData != null && sessionsData!.isNotEmpty
          ? ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Button added outside the card, at the top of the list
          ElevatedButton(
            onPressed: () {
              _showSessionForm();
            },
            child: Text('Today\'s Sessions'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
          SizedBox(height: 16),
          // List of sessions displayed as cards
          ...sessionsData!.map((session) {
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: Text(session.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Faculty: ${session.faculty}'),
                    Text('Date: ${session.date}'),
                    Text('Time: ${session.time}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _showSessionForm(session: session),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteSession(session.id),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      )
          : Center(child: Text('No Sessions Data Available')),
    );
  }
}

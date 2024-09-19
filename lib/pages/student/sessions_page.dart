import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/sessions.dart';
import '../../services/student_service.dart';
import 'package:url_launcher/url_launcher.dart'; // To launch Zoom links

class SessionsPage extends StatefulWidget {
  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final StudentService _studentService = StudentService();
  bool isLoading = true;
  List<Session>? sessionsData;
  List<String> sessionTitles = [];
  String? selectedSession;

  @override
  void initState() {
    super.initState();
    _fetchSessionsData();
  }

  Future<void> _fetchSessionsData() async {
    try {
      List<Session> data = await _studentService.fetchSessionsData();
      Set<String> sessionSet = data.map((session) => session.title).toSet();
      sessionTitles = sessionSet.toList();

      setState(() {
        sessionsData = data;
        selectedSession = sessionTitles.isNotEmpty ? sessionTitles[0] : null;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching sessions data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Session> _filterSessionData(String sessionTitle) {
    return sessionsData
        ?.where((session) => session.title == sessionTitle)
        .toList() ?? [];
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Stack(
            children: [
              // Banner Image
              Image.asset(
                'assets/images/banse.png',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/back_arrow.svg',
                    color: Colors.white,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

            ],
          ),
          const SizedBox(height: 20),

          // Dropdown for available sessions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: selectedSession,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                filled: true,
                fillColor: Color(0xFFFEBE10), // Yellow background
                hintText: 'Today\'s Available Sessions',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
              dropdownColor: Color(0xFFFEBE10),
              iconEnabledColor: Colors.black,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSession = newValue!;
                });
              },
              items: sessionTitles
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Display session details and zoom link
          Expanded(
            child: selectedSession != null
                ? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$selectedSession Session Details',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildSessionDetailsContent(),
                      ],
                    ),
                  ),
                ),
              ],
            )
                : Center(child: Text('Please select a session')),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetailsContent() {
    var data = _filterSessionData(selectedSession!);
    if (data.isNotEmpty) {
      Session session = data.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailText('Faculty: ${session.faculty}'),
          _buildDetailText('Date: ${session.date}'),
          _buildDetailText('Time: ${session.time}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _launchURL(session.zoomLink),
            style: ElevatedButton.styleFrom(
              backgroundColor:  Color(0xFFFEBE10), // Zoom button color
            ),
            child: Text('Join Class Online'),
          ),
        ],
      );
    } else {
      return Text('No data available.');
    }
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
      ),
    );
  }
}

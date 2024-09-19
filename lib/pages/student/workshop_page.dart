import 'package:flutter/material.dart';
import '../../services/student_service.dart';
import '../../models/workshop.dart';

class WorkshopPage extends StatefulWidget {
  @override
  _WorkshopPageState createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final StudentService _studentService = StudentService();
  bool isLoading = true;
  List<Workshops>? workshopsData;
  String? selectedWorkshop;
  Workshops? selectedWorkshopDetails;

  @override
  void initState() {
    super.initState();
    _fetchWorkshopData();
  }

  Future<void> _fetchWorkshopData() async {
    try {
      List<Workshops> data = await _studentService.fetchWorkshopData();
      setState(() {
        workshopsData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching workshop data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onWorkshopSelected(String? workshopTitle) {
    setState(() {
      selectedWorkshop = workshopTitle;
      selectedWorkshopDetails = workshopsData
          ?.firstWhere((workshop) => workshop.title == workshopTitle);
    });
  }

  Future<void> _registerForWorkshop(Workshops workshop) async {
    print("Registering for workshop: ${workshop.title}");
    // Handle the registration process here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workshops'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Added ScrollView to prevent overflow
        child: Column(
          children: [
            Image.asset(
              'assets/images/workshop_B.webp',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Available Workshops',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedWorkshop,
                hint: Text('Select a Workshop'),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  filled: true,
                  fillColor: Color(0xFFFEBE10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.black),
                dropdownColor: Color(0xFFFEBE10),
                iconEnabledColor: Colors.black,
                onChanged: _onWorkshopSelected,
                items: workshopsData
                    ?.map((workshop) => DropdownMenuItem<String>(
                  value: workshop.title,
                  child: Text(workshop.title),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedWorkshopDetails != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedWorkshopDetails!.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Faculty: ${selectedWorkshopDetails!.faculty}'),
                        Text('Date: ${selectedWorkshopDetails!.date}'),
                        Text('Description: ${selectedWorkshopDetails!.description}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _registerForWorkshop(selectedWorkshopDetails!);
                          },
                          child: Text('Register for Workshop'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFEBE10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

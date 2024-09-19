import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('applications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final applications = snapshot.data?.docs ?? [];
          if (applications.isEmpty) {
            return Center(child: Text('No applications available'));
          }

          return ListView(
            children: applications.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text('${data['applicationType']}: ${data['details']}'),
                trailing: Text(data['submittedAt'].toDate().toLocal().toString()),
                onTap: () {
                  // Show detailed information or perform actions
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

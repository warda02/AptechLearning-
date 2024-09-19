import 'package:flutter/material.dart';
import '../../models/payment.dart';
import 'faculty_services/FacultyService.dart';

class PaymentListPage extends StatefulWidget {
  final String studentId;

  PaymentListPage({required this.studentId});

  @override
  _PaymentListPageState createState() => _PaymentListPageState();
}

class _PaymentListPageState extends State<PaymentListPage> {
  final FacultyService _facultyService = FacultyService();
  late Future<List<Payment>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _facultyService.fetchPaymentsForStudent(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: FutureBuilder<List<Payment>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payments found.'));
          }

          List<Payment> payments = snapshot.data!;

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              Payment payment = payments[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Student: ${payment.studentName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount Paid: ${payment.amountPaid}'),
                      Text('Payment Date: ${payment.paymentDate}'),
                      Text('Status: ${payment.status}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

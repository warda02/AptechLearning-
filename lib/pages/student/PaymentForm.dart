import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/FeesStatus.dart';

class PaymentForm extends StatefulWidget {
  final FeesStatus feeData;

  PaymentForm({required this.feeData});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String cardHolderName = '';

  void _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        print('Updating document with ID: ${widget.feeData.id}'); // Debug statement

        // Add payment record
        await FirebaseFirestore.instance.collection('payments').add({
          'studentId': 'O1FsNm0PkQU5i1pQrj2q9yUOknA2', // Replace with actual student ID
          'cardNumber': cardNumber,
          'cardHolderName': cardHolderName,
          'amountPaid': widget.feeData.amount,
          'paymentDate': Timestamp.now(),
          'status': 'Paid',
        });

        // Verify document existence before updating
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('fees').doc(widget.feeData.id).get();
        if (doc.exists) {
          await FirebaseFirestore.instance.collection('fees').doc(widget.feeData.id).update({
            'status': 'Paid',
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fees have been paid successfully!')),
          );

          Navigator.of(context).pop(true); // Indicate success
        } else {
          throw Exception('Document does not exist');
        }
      } catch (e) {
        print('Error during payment submission: $e'); // Print error to console
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
    }
  }






  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Payment Form'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Card Number'),
              onChanged: (value) => cardNumber = value,
              validator: (value) => value!.isEmpty ? 'Please enter card number' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Card Holder Name'),
              onChanged: (value) => cardHolderName = value,
              validator: (value) => value!.isEmpty ? 'Please enter card holder name' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPayment,
              child: Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

 const express = require('express');
 const admin = require('firebase-admin');
 const cors = require('cors');

 // Initialize Firebase Admin SDK
 const serviceAccount = require('./serviceAccountKey.json'); // Path to your service account key

 admin.initializeApp({
   credential: admin.credential.cert(serviceAccount),
 });

 const db = admin.firestore(); // Initialize Firestore

 const app = express();
 app.use(express.json());
 app.use(cors());

 // API endpoint to handle fee payment
 app.post('/pay', async (req, res) => {
   try {
     const { studentId, amount } = req.body;

     if (!studentId || !amount) {
       return res.status(400).json({
         success: false,
         error: 'Missing studentId or amount in request body.',
       });
     }

     // Reference to the student document in Firestore
     const studentRef = db.collection('students').doc(studentId);

     // Get the student's data
     const studentDoc = await studentRef.get();

     if (!studentDoc.exists) {
       return res.status(404).json({
         success: false,
         error: 'Student not found.',
       });
     }

     // Update the fee status in Firestore
     await studentRef.update({
       feeStatus: 'Paid',
       amountPaid: amount,
       paymentDate: new Date().toISOString(),
     });

     res.json({ success: true });
   } catch (error) {
     console.error('Error handling payment:', error.message);
     res.status(500).json({ success: false, error: error.message });
   }
 });

 app.listen(3000, () => console.log('Server running on port 3000'));

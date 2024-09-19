import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> setupFirestoreStructure() async {
  final firestore = FirebaseFirestore.instance;

  // Define Faculty Data
  final facultyData = {
    'name': 'Mubashir Hussain',
    'email': 'mubashir@domain.com',
    'phone': '9876543210',
    'position': 'Senior Faculty',
  };

  // Create or update Faculty document
  final facultyRef = firestore.collection('faculties').doc('WRtAVZxrMKWwB0rufE5HFYiJBLA3');
  await facultyRef.set(facultyData);

  // Define Student Data
  final students = [
    {
      'name': 'Warda Fatima',
      'email': 'warda.e.fatima@gmail.com',
      'phone': '1234567890',
      'address': '123 Main St',
      'enrollmentDate': Timestamp.now(),
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGLRAlpUwgnA01Ksosn99mzvGi1dZEeLS0Mw&s',
    },
    {
      'name': 'Ali Raza',
      'email': 'ali@gmail.com',
      'phone': '2345678901',
      'address': '456 Elm St',
      'enrollmentDate': Timestamp.now(),
      'imageUrl': 'https://example.com/ali_khan.jpg',
    },
    {
      'name': 'Sawera',
      'email': 'sawera@gmail.com',
      'phone': '3456789012',
      'address': '789 Pine St',
      'enrollmentDate': Timestamp.now(),
      'imageUrl': 'https://example.com/sawera.jpg',
    },
  ];

  // Add each student to the faculty's students collection
  for (var student in students) {
    final studentId = student['name'] == 'Warda Fatima'
        ? 'O1FsNm0PkQU5i1pQrj2q9yUOknA2'
        : student['name'] == 'Ali Raza'
        ? 'qznGLE5aVcgROYIOW1HNWMOnG9n1'
        : 'X8ur0izQuNTyf4EDnOYGd4BIOm22';

    final studentRef = facultyRef.collection('students').doc(studentId);
    await studentRef.set(student);

    // Example data for each student

    // Performance records
    final performanceRecords = [
      {
        'courseName': 'Course 1',
        'moduleName': 'Module 1',
        'totalMarks': 100,
        'marksObtained': 90,
        'weightage': 0.4,
        'examType': 'semester 1',
      },
      {
        'courseName': 'Course 2',
        'moduleName': 'Module 2',
        'totalMarks': 100,
        'marksObtained': 85,
        'weightage': 0.3,
        'examType': 'semester 2',
      },
    ];
    for (var record in performanceRecords) {
      await studentRef.collection('performanceRecords').add(record);
    }

    // Attendance
    final attendanceRecords = [
      {
        'date': Timestamp.now(),
        'status': 'Present',
      },
      {
        'date': Timestamp.now(),
        'status': 'Absent',
      },
    ];
    for (var record in attendanceRecords) {
      await studentRef.collection('attendance').add(record);
    }

    // Fees status
    final feesStatus = [
      {
        'amount': 5000,
        'status': 'Paid',
        'date': Timestamp.now(),
      },
      {
        'amount': 5000,
        'status': 'Pending',
        'dueDate': Timestamp.now(),
      },
    ];
    for (var status in feesStatus) {
      await studentRef.collection('feesStatus').add(status);
    }

    // Exams
    final exams = [
      {
        'examName': 'Exam 1',
        'courseName': 'Course 1',
        'date': Timestamp.now(),
        'totalMarks': 100,
        'marksObtained': 90,
      },
      {
        'examName': 'Exam 2',
        'courseName': 'Course 2',
        'date': Timestamp.now(),
        'totalMarks': 100,
        'marksObtained': 85,
      },
    ];
    for (var exam in exams) {
      await studentRef.collection('exams').add(exam);
    }

    // Assignments
    final assignments = [
      {
        'title': 'Assignment 1',
        'dueDate': Timestamp.now(),
        'status': 'Completed',
      },
      {
        'title': 'Assignment 2',
        'dueDate': Timestamp.now(),
        'status': 'Pending',
      },
    ];
    for (var assignment in assignments) {
      await studentRef.collection('assignments').add(assignment);
    }

    // Quizzes
    final quizzes = [
      {
        'title': 'Quiz 1',
        'date': Timestamp.now(),
        'totalMarks': 20,
        'marksObtained': 18,
      },
      {
        'title': 'Quiz 2',
        'date': Timestamp.now(),
        'totalMarks': 20,
        'marksObtained': 16,
      },
    ];
    for (var quiz in quizzes) {
      await studentRef.collection('quizzes').add(quiz);
    }

    // Games
    final games = [
      {
        'gameName': 'Game 1',
        'date': Timestamp.now(),
        'score': '2-1',
      },
      {
        'gameName': 'Game 2',
        'date': Timestamp.now(),
        'score': '80-75',
      },
    ];
    for (var game in games) {
      await studentRef.collection('games').add(game);
    }
  }
}

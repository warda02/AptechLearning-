class PerformanceRecord {
  final String id;
  final String courseName;
  final String examType;
  final int marksObtained;
  final String moduleName;
  final int totalMarks;
  final double weightage;
  final double gpa;
  final String imageUrl; // Changed from double to String
  final int attendancePercentage;
  final String classParticipation;
  final String punctuality;
  final String classBehavior;
  final String teacherFeedback;
  final String performanceSummary;

  PerformanceRecord({
    required this.id,
    required this.courseName,
    required this.examType,
    required this.marksObtained,
    required this.moduleName,
    required this.totalMarks,
    required this.weightage,
    required this.gpa,
    required this.imageUrl, // Updated here
    required this.attendancePercentage,
    required this.classParticipation,
    required this.punctuality,
    required this.classBehavior,
    required this.teacherFeedback,
    required this.performanceSummary,
  });

  factory PerformanceRecord.fromMap(Map<String, dynamic> data, String id) {
    return PerformanceRecord(
      id: id,
      courseName: data['courseName'] ?? '',
      examType: data['examType'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // Ensure this field is handled correctly
      marksObtained: data['marksObtained'] ?? 0,
      moduleName: data['moduleName'] ?? '',
      totalMarks: data['totalMarks'] ?? 0,
      weightage: data['weightage'] ?? 0.0,
      gpa: data['gpa'] ?? 0.0,
      attendancePercentage: data['attendancePercentage'] ?? 0,
      classParticipation: data['classParticipation'] ?? '',
      punctuality: data['punctuality'] ?? '',
      classBehavior: data['classBehavior'] ?? '',
      teacherFeedback: data['teacherFeedback'] ?? '',
      performanceSummary: data['performanceSummary'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'examType': examType,
      'marksObtained': marksObtained,
      'moduleName': moduleName,
      'totalMarks': totalMarks,
      'weightage': weightage,
      'gpa': gpa,
      'imageUrl': imageUrl, // Added here
      'attendancePercentage': attendancePercentage,
      'classParticipation': classParticipation,
      'punctuality': punctuality,
      'classBehavior': classBehavior,
      'teacherFeedback': teacherFeedback,
      'performanceSummary': performanceSummary,
    };
  }
}

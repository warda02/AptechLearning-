
class Attendance {
  final String id;
  final String semester;

  final int totalSessions;
  final int totalSessionsAttended;
  final double attendance;

  Attendance({
    required this.id,
    required this.semester,

    required this.totalSessions,
    required this.totalSessionsAttended,
    required this.attendance,
  });

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] ?? '',
      semester: map['semester'] ?? '',

      totalSessions: int.parse(map['totalSessions'] ?? '0'),
      totalSessionsAttended: int.parse(map['Total Sessions Attended'] ?? '0'),
      attendance: double.parse(map['Attendance'] ?? '0.0'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'semester': semester,
      'totalSessions': totalSessions,
      'Total Sessions Attended': totalSessionsAttended,
      'Attendance': attendance,
    };
  }
}

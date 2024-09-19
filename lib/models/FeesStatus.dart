class FeesStatus {
  final String id;
  final String month;
  final String studentId;
  final double amount;
  final double amountAfterDueDate;
  final String dueDate;
  final String status;
  final String date;

  FeesStatus({
    required this.id,
    required this.month,
    required this.studentId,
    required this.amount,
    required this.amountAfterDueDate,
    required this.dueDate,
    required this.status,
    required this.date,
  });

  // Factory constructor to create FeesStatus from Firestore data
  factory FeesStatus.fromMap(Map<String, dynamic> data, String id) {
    return FeesStatus(
      id: id,
      month: data['month'] ?? '', // Ensure this is a String
      studentId: data['studentId'] ?? '', // Ensure this is a String
      amount: _parseDouble(data['amount']), // Parse to double safely
      amountAfterDueDate: _parseDouble(data['amountAfterDueDate']),
      dueDate: data['dueDate'] ?? '', // Ensure this is a String
      status: data['status'] ?? '', // Ensure this is a String
      date: data['date'] ?? '', // Ensure this is a String
    );
  }

  // Safely parse the data to double
  static double _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  // Convert FeesStatus back to a Map (for saving/updating data)
  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'amount': amount,
      'amountAfterDueDate': amountAfterDueDate,
      'dueDate': dueDate,
      'status': status,
      'date': date,
    };
  }
}

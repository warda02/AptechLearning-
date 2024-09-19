class Registration {
  final String name;
  final String email;
  final String phone;
  final String course;
  final String city;
  final List<String> days; // Ensure this is a List<String>
  final List<String> timeSlots;

  Registration({
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.city,
    required this.days, // List<String> here
    required this.timeSlots,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      course: json['course'],
      city: json['city'],
      days: List<String>.from(json['days']),
      timeSlots: List<String>.from(json['timeSlots']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'course': course,
      'city': city,
      'days': days, // Ensure this is a List<String>
      'timeSlots': timeSlots,
    };
  }
}

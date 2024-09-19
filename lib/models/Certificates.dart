class Certificates {
  final String id;
  final String dateIssued;
  final String issuedBy;
  final String title;
  final String imageUrl;

  Certificates({
    required this.id,
    required this.dateIssued,
    required this.issuedBy,
    required this.title,
    required this.imageUrl,
  });

  factory Certificates.fromMap(Map<String, dynamic> data, String id) {
    return Certificates(
      id: id,
      dateIssued: data['dateIssued'] ?? '',
      issuedBy: data['issuedBy'] ?? '',
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateIssued': dateIssued,
      'issuedBy': issuedBy,
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}

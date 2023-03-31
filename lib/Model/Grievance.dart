class Grievance {
  final String title;
  final String deparment;
  final String description;
  final DateTime? date;
  final String? response;

  Grievance({
    required this.response,
    required this.title,
    required this.description,
    required this.deparment,
    required this.date,
  });

  factory Grievance.fromJson(json) {
    return Grievance(
      response: json['response'],
      title: json['title'],
      description: json['description'],
      deparment: json['department'],
      date: json['date'] == null ? null : DateTime.parse(json['date']),
    );
  }
}

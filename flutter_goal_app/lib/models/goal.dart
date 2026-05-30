class Goal {
  Goal({this.id, required this.title, required this.category, required this.term, required this.status, required this.notes});

  int? id;
  String title, category, term, status, notes;

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: int.tryParse(json['id'].toString()),
        title: json['title'] ?? '',
        category: json['category'] ?? 'Personal',
        term: json['term'] ?? 'Short Term',
        status: json['status'] ?? 'Not Started',
        notes: json['notes'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'category': category,
        'term': term,
        'status': status,
        'notes': notes,
      };
}

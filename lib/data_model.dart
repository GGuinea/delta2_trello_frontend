class Data {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({this.id, this.title, this.body, this.createdAt, this.updatedAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']));
  }
}

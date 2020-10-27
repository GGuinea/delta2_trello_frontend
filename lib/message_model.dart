import 'package:delta2_trello_frontend/data_model.dart';

class Message {
  final String status;
  final String message;
  final List<Data> data;

  Message(this.status, this.message, [this.data]);

  factory Message.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      var dataObjsJson = json['data'] as List;
      List<Data> _data =
          dataObjsJson.map((tagJson) => Data.fromJson(tagJson)).toList();

      return Message(
          json['status'] as String,
          json['message'] as String,
          _data);
    } else {
      return Message(
        json['status'] as String,
        json['message'] as String,
      );
    }
  }
}

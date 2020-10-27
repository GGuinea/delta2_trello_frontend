import 'dart:convert';

import 'package:delta2_trello_frontend/message_model.dart';
import 'package:http/http.dart';

class HttpService {
  final String url = "https://trellodelta.herokuapp.com/";

  Future<Message> getMessage() async {
    Response response = await get(url + "api/v1/users");
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Message message = Message.fromJson(body);
      return message;
    }
  }
}

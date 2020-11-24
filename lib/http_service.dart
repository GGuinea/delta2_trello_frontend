import 'dart:async';

import 'package:http/http.dart' as http;

final String url = "https://trellodelta.herokuapp.com";

Future<http.Response> login(String username, String password) async {
  http.Response response =
      await http.post('$url' + "/api/v1/login", body: {"username": username, "password": password});
  return response;
}

Future<http.Response> signUp(String email, String username, String password) async {
  http.Response response = await http.post('$url' + "/api/v1/users",
      body: {"email": email, "username": username, "password": password});
  return response;
}

Future<http.Response> getAllBoards(String token) async {
  http.Response response =
      await http.get('$url' + "/api/v1/all_boards", headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> changeBoardName(String token, String name, int id) async {
  http.Response response = await http.patch('$url' + "/api/v1/board/" + '$id',
      headers: {"Authorization": "Bearer " + token}, body: {"name": name});
  return response;
}

Future<http.Response> changeBoardDescription(String token, String description, int id) async {
  http.Response response = await http.patch('$url' + "/api/v1/board/" + '$id',
      headers: {"Authorization": "Bearer " + token}, body: {"description": description});
  return response;
}

Future<http.Response> deleteBoard(String token, int id) async {
  http.Response response = await http
      .delete('$url' + "/api/v1/board/" + '$id', headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> getDetailsBoard(String token, int id) async {
  http.Response response = await http
      .get('$url' + "/api/v1/board/" + '$id', headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> createBoard(String token, String name, String description) async {
  http.Response response = await http.post('$url' + "/api/v1/boards",
      headers: {"Authorization": "Bearer " + token},
      body: {"name": name, "description": description});
  return response;
}

Future<http.Response> addMember(String token, int boardId, String email) async {
  http.Response response = await http.patch('$url' + "/api/v1/board/add_member/" + '$boardId',
      headers: {"Authorization": "Bearer " + token},
      body: {"email": email});
  return response;
}
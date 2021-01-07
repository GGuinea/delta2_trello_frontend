import 'dart:async';

import 'package:delta2_trello_frontend/task_list.dart';
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

Future<http.Response> updateColumn(String token, String name, int id) async {
  http.Response response = await http.patch('$url' + "/api/v1/column/" + '$id',
      headers: {"Authorization": "Bearer " + token}, body: {"name": name});
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
  http.Response response = await http.patch('$url' + "/api/v1/board/member/" + '$boardId',
      headers: {"Authorization": "Bearer " + token},
      body: {"email": email});
  return response;
}
Future<http.Response> addMemberById(String token, int boardId, int idUser) async {
  http.Response response = await http.patch('$url' + "/api/v1/board/member/" + '$boardId' + "/" +idUser.toString(),
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> deleteMember(String token, int boardId, int userId) async {
  http.Response response = await http.delete('$url' + "/api/v1/board/member/" + '$boardId' + "/" + '$userId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> getMembers(String token, int boardId) async {
  http.Response response = await http.get('$url' + "/api/v1/get_users/" + '$boardId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> addColumn(String token, int boardId, String name) async {
  http.Response response = await http.post('$url' + "/api/v1/" + '$boardId' + "/column",
      headers: {"Authorization": "Bearer " + token},
      body: {'name': name});
  return response;
}

Future<http.Response> getLists(String token, int boardId) async {
  http.Response response = await http.get('$url' + "/api/v1/" + '$boardId' + "/columns",
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> addCard(String token, int columnId, String name, String description) async {
  http.Response response = await http.post('$url' + "/api/v1/" + '$columnId' + "/card",
      headers: {"Authorization": "Bearer " + token},
      body: {'name': name, "description": description});
  return response;
}

Future<http.Response> deleteCard(String token, int cardId) async {
  http.Response response = await http.delete('$url' + "/api/v1/card/" + '$cardId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> updateCard(
    String token, int cardId, String name, String description, String deadline, int columnId) async {
  http.Response response = await http.patch(
      '$url' + "/api/v1/card/" + '$cardId',
      headers: {"Authorization": "Bearer " + token},
      body: {'name': name,'description': description, 'deadline': deadline, 'column_id':columnId.toString()});
  return response;
}

Future<http.Response> addTask(
    String token, int cardId, String name, bool done) async {
  http.Response response = await http.post(
      '$url' + "/api/v1/add/task/" + '$cardId',
      headers: {"Authorization": "Bearer " + token},
      body: {'name': name, 'done': done.toString()});
  return response;
}

Future<http.Response> getTasks(String token, int cardId) async {
  http.Response response = await http.get(
      '$url' + "/api/v1/" + '$cardId' + "/tasks",
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> updateTask(String token, int taskId, String name, bool done) async {
  http.Response response = await http.patch(
      '$url' + "/api/v1/task/" + '$taskId',
      headers: {"Authorization": "Bearer " + token},
      body: {'name': name, 'done': done.toString()});
  return response;
}

Future<http.Response> deleteTask(String token, int taskId) async {
  http.Response response = await http.delete(
      '$url' + "/api/v1/remove/task/" + '$taskId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> updateWallpaper(String token, int boardId,
    String wallpaper) async {
  http.Response response = await http.patch(
      '$url' + "/api/v1/board/" + '$boardId',
      headers: {"Authorization": "Bearer " + token},
      body: {'background_id': wallpaper});
  return response;
}
Future<http.Response> addLabelToCard(
    String token, int cardId, int labelId) async {
  http.Response response = await http.post(
      '$url' + "/api/v1/" + '$cardId' +"/"+ '$labelId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}
Future<http.Response> updateLabel(String token, int labelId, String name) async {
  http.Response response = await http.patch(
      '$url' + "/api/v1/label/" + '$labelId',
      headers: {"Authorization": "Bearer " + token},
      body: {'name': name});
  return response;
}

Future<http.Response> deleteLabelFromCard(String token, int cardId,int labelId) async {
  http.Response response = await http.delete('$url' + "/api/v1/" + '$cardId'+"/"+ '$labelId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}

Future<http.Response> deleteList(String token, int columnId) async {
  http.Response response = await http.delete('$url' + "/api/v1/column/" + '$columnId',
      headers: {"Authorization": "Bearer " + token});
  return response;
}

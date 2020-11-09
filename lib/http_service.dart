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

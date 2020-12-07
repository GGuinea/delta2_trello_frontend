import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'http_service.dart';

TextEditingController passwordController = new TextEditingController();
TextEditingController usernameController = new TextEditingController();

class InvitePage extends StatefulWidget {
  final String credentials;

  const InvitePage({Key key, this.credentials}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState(credentials);
}

class _InvitePageState extends State<InvitePage> {
  final String credentials;
  String username;
  String boardName;
  int boardId;
  final _formKey = GlobalKey<FormState>();
  String _error;

  _InvitePageState(this.credentials);

  @override
  void initState() {
    List<String> decoded = utf8.decode(base64.decode(credentials)).split("/#/");
    username = decoded[0];
    boardName = decoded[1];
    boardId = int.parse(decoded[2]);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            toolbarOpacity: 0.7,
            centerTitle: true,
            title: Image.asset(
              'images/Trello_logo_white.png',
              height: 32,
            ),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: new TextSpan(
                        style: new TextStyle(fontSize: 25, color: Colors.black),
                        children: <TextSpan>[
                          new TextSpan(
                              text: username, style: new TextStyle(fontWeight: FontWeight.bold)),
                          new TextSpan(text: " invite you to "),
                          new TextSpan(
                              text: boardName, style: new TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 400,
                    width: 400,
                    color: backgroundColor,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Log in to Trello and join to table",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(
                              height: 64,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Username is required";
                                }
                                return null;
                              },
                              controller: usernameController,
                              decoration: InputDecoration(
                                  hintText: 'Enter username',
                                  suffixIcon: Icon(
                                    Icons.mail_outline,
                                  )),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Password is required";
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'Enter password',
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                    ))),
                            SizedBox(
                              height: 32,
                            ),
                            _error == null
                                ? Container()
                                : Text(
                                    _error,
                                    style: TextStyle(color: Colors.red, fontSize: 16),
                                  ),
                            SizedBox(
                              height: 32,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  final String username = usernameController.text;
                                  final String password = passwordController.text;
                                  login(username, password).then((response) {
                                    if (response.statusCode == 200) {
                                      print(response.body);
                                      window.localStorage['token'] = jsonDecode(response.body)['token'];
                                      window.localStorage['username'] = username;
                                      addMemberById(window.localStorage['token'], boardId, jsonDecode(response.body)['userId'])
                                          .then((response) {
                                        if (response.statusCode == 200) {
                                          Navigator.pushNamed(context, "/boards/" + username);
                                          passwordController.clear();
                                          usernameController.clear();
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _error = json.decode(response.body)['error'];
                                      });
                                    }
                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Log in and join",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

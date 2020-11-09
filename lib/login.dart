import 'dart:convert';

import 'package:delta2_trello_frontend/constants.dart';
import 'package:delta2_trello_frontend/http_service.dart';
import 'package:delta2_trello_frontend/test_page.dart';
import 'package:delta2_trello_frontend/user_model.dart';
import 'package:delta2_trello_frontend/boards.dart';
import 'package:flutter/material.dart';

TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

class LogIn extends StatefulWidget {
  final Function onSignUpSelected;

  LogIn({@required this.onSignUpSelected});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  String _error;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(size.height > 770  ? 64 : size.height > 670 ? 32 : 16),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: size.height * (size.height > 770 ? 0.65 : size.height > 670 ? 0.75 : 0.85),
              width: 400,
              color: backgroundColor,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log in to Trello",
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
                                  if (response.body.contains("error")) {
                                    setState(() {
                                      _error = json.decode(response.body)['error'];
                                    });
                                  } else {
                                    userToken = jsonDecode(response.body)['token'];
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Boards();
                                    }));
                                  }
                                } else {
                                  setState(() {
                                    _error = response.body;
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
                                "Log in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onSignUpSelected();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign up for an account',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.arrow_right_alt_outlined,
                                color: kPrimaryColor,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

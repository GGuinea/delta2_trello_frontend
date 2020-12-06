import 'dart:convert';

import 'package:delta2_trello_frontend/boards.dart';
import 'package:delta2_trello_frontend/constants.dart';
import 'package:delta2_trello_frontend/http_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class LogIn extends StatefulWidget {
  final Function onSignUpSelected;

  LogIn({@required this.onSignUpSelected});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  String _error;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((googleUser) {
        if (googleUser != null) {
          signUp(googleUser.email, googleUser.displayName, googleUser.id).then((response) {
            print(response.statusCode);
            if (response.statusCode == 200 || response.statusCode == 409) {
              login(googleUser.displayName, googleUser.id).then((response) {
                if (response.statusCode == 200) {
                  userToken = jsonDecode(response.body)['token'];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Boards(username: googleUser.displayName);
                  }));
                } else {
                  setState(() {
                    _error = json.decode(response.body)['error'];
                  });
                }
              });
            } else {
              setState(() {
                _error = json.decode(response.body)['error'];
              });
            }
          });
        }
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(size.height > 770
            ? 64
            : size.height > 670
                ? 32
                : 16),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: size.height *
                  (size.height > 770
                      ? 0.65
                      : size.height > 670
                          ? 0.75
                          : 0.85),
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
                                  userToken = jsonDecode(response.body)['token'];
                                  Navigator.pushNamed(context, "/boards/" + username);
                                  passwordController.clear();
                                  usernameController.clear();
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
                        RaisedButton(
                          onPressed: _handleSignIn,
                          color: Colors.white,
                          hoverColor: Colors.white,
                          child: Container(
                            height: 25,
                            width: double.infinity,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Image.network('assets/images/google_icon.png'),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ]),
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

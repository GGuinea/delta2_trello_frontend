import 'dart:convert';

import 'package:delta2_trello_frontend/constants.dart';
import 'package:delta2_trello_frontend/http_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController passwordConfirmController = new TextEditingController();

class SignUp extends StatefulWidget {
  final Function onLogInSelected;

  SignUp({@required this.onLogInSelected});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _error;
  String _information;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
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
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign up for your account",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        _information == null
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  widget.onLogInSelected();
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _information,
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Log In',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.arrow_right_alt_outlined,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email is required";
                            } else if (!EmailValidator.validate(value)) {
                              return "Invalid email";
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: 'Enter email',
                              suffixIcon: Icon(
                                Icons.mail_outline,
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) return "Username is required";
                            return null;
                          },
                          controller: usernameController,
                          decoration: InputDecoration(
                              hintText: 'Enter username',
                              suffixIcon: Icon(
                                Icons.person_outline,
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty)
                                return "Password is required";
                              else if (value.length < 8)
                                return "Passwords must contains 8 characters";
                              else if (!validatePassword(value))
                                return "Password must contain upper and lower case letters,\n"
                                    "numbers and a special characters[!@#\$&*~].";
                              else if (value != passwordConfirmController.text)
                                return "Passwords are different";
                              return null;
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                              suffixIcon: Icon(
                                Icons.lock_outline,
                              ),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty)
                                return "Password is required";
                              else if (value != passwordController.text)
                                return "Passwords are different";
                              return null;
                            },
                            controller: passwordConfirmController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Confirm password',
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
                              final String email = emailController.text;
                              final String username = usernameController.text;
                              final String password = passwordController.text;
                              signUp(email, username, password).then((response) {
                                if (response.statusCode == 200) {
                                    setState(() {
                                      _information = jsonDecode(response.body)['status'];
                                      _error = null;
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
                                "Sign Up",
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
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onLogInSelected();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? Log In',
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
                        ),
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

bool validatePassword(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

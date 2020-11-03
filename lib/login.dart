import 'package:delta2_trello_frontend/constants.dart';
import 'package:flutter/material.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

class LogIn extends StatefulWidget {
  final Function onSignUpSelected;

  LogIn({@required this.onSignUpSelected});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
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
            color: Colors.white24,
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
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Enter email',
                            suffixIcon: Icon(
                              Icons.mail_outline,
                            )),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Enter password',
                              suffixIcon: Icon(
                                Icons.lock_outline,
                              ))),
                      SizedBox(
                        height: 64,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Log in');
                          print('Email : ' + emailController.text);
                          print('Password : ' + passwordController.text);
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
    );
  }
}

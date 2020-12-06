import 'package:delta2_trello_frontend/signup.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Option selectedOption = Option.LogIn;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width,
                  color: backgroundColor,
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.network('assets/images/left_photo_background.jpg',
                  width: 375, height: 375),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.network('assets/images/right_photo_background.jpg',
                  width: 375, height: 275),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.network('assets/images/atlassian_logo.png',
                  width: 150, height: 100),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.network('assets/images/Trello_logo.png',
                          width: 200, height: 40)),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (widget, animation) => ScaleTransition(
                      scale: animation,
                      child: widget,
                    ),
                    child: selectedOption == Option.LogIn
                        ? LogIn(
                      onSignUpSelected: () {
                        setState(() {
                          selectedOption = Option.SignUp;
                        });
                      },
                    )
                        : SignUp(onLogInSelected: () {
                      setState(() {
                        selectedOption = Option.LogIn;
                      });
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
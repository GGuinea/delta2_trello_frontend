import 'package:delta2_trello_frontend/login.dart';
import 'package:delta2_trello_frontend/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.secularOneTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

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
                  color: Colors.white24,
                )
              ],
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Image.asset('images/Trello_logo.png',
                      width: 200, height: 40)),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset('images/left_photo_background.jpg',
                  width: 375, height: 375),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset('images/right_photo_background.jpg',
                  width: 375, height: 275),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  Image.asset('images/atlassian.png', width: 150, height: 100),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedSwitcher(
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
            )
          ],
        ),
      ),
    );
  }
}

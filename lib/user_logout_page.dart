import 'dart:ui';

import 'package:flutter/material.dart';

import 'constants.dart';

class LogoutUserPage extends StatelessWidget {
  const LogoutUserPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: [
            Text(
              'You are logout',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/");
              },
              textColor: Colors.black54,
              color: kPrimaryColor,
              hoverColor: Colors.lightGreenAccent,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: const Text('Log In', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
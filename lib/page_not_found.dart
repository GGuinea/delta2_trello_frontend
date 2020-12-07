import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({
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
              'Page not found',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:delta2_trello_frontend/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("There will be trello app here in the future!!"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Click o this button to see more"),
            FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(),
              )),
              tooltip: "Click me please!",
              child: Icon(Icons.slideshow),
            )
          ],
        ),
      ),
    );
  }
}

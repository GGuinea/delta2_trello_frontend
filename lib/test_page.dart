import 'package:delta2_trello_frontend/constants.dart';
import 'package:flutter/material.dart';

class testPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text("User login successfully"),
            SizedBox(
              height: 50,
            ),
            Text("User token: " + userToken,
            style: TextStyle(
              fontSize: 14
            ),)
          ],
        ),
      ),
    );
  }
}

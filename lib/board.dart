import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget{
  @override
  _BoardState createState() => _BoardState();

}

class _BoardState extends State<Board> {
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
    );
  }
}
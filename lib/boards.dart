import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Boards extends StatefulWidget {
  @override
  _BoardsState createState() => _BoardsState();
}

class _BoardsState extends State<Boards> {
  List<String> boards = [];
  TextEditingController _boardNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBoards(),
      backgroundColor: kPrimaryColor,
    );
  }

  _buildBoards() {
    Size size = MediaQuery.of(context).size;
    return GridView.count(
      childAspectRatio: 16 / 9,
      crossAxisCount: (size.width > 1200
          ? 6
          : size.width > 900
              ? 5
              : size.width > 600
                  ? 4
                  : 3),
      children: List.generate(boards.length + 1, (index) {
        if (index == boards.length)
          return InkWell(
            onTap: _showAddBoardDialog,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
              ),
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text(
                "Create new board",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          );
        else
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
              ),
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text(
                boards[index],
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
      }),
    );
  }

  _showAddBoardDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Board title"),
                    controller: _boardNameTextController,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      onPressed: () {
                        if (_boardNameTextController.text.trim() != "") {
                          Navigator.of(context).pop();
                          _addBoard(_boardNameTextController.text.trim());
                        }
                      },
                      child: Text("Add board"),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  _addBoard(String boardName) {
    boards.add(boardName);
    _boardNameTextController.clear();
    setState(() {});
  }
}

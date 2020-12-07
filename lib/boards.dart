import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'http_service.dart';

class Boards extends StatefulWidget {
  final String username;
  const Boards({Key key, this.username}) : super(key: key);
  @override
  _BoardsState createState() => _BoardsState(username);
}

class _BoardsState extends State<Boards> {
  List boards = [];
  TextEditingController _boardNameTextController = TextEditingController();
  final String username;

  _BoardsState(this.username);
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_box_rounded,
            ),
            onPressed: () {
              _showAddBoardDialog();
            },
            iconSize: 32,
            tooltip: "Add board"
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              window.localStorage.remove('token');
              Navigator.pushNamed(context, "/");
            },
            iconSize: 32,
            tooltip: "Logout",
          )
        ],
      ),
      body: _buildBoards(),
      backgroundColor: Colors.white,
    );
  }

  @override
  initState() {
    super.initState();
    fetchBoards();
  }

  fetchBoards() {
    getAllBoards(window.localStorage['token']).then((response) => {
          if (response.statusCode == 200)
            {
              setState(() {
                boards.addAll(jsonDecode(response.body)['boards']);
              })
            }
        });
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
            onTap: () {
              Navigator.pushNamed(context, "/board/"+username+"/"+boards[index]["id"].toString());
            },
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
                boards[index]['name'].toString(),
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
            child: SizedBox(
              width: 500,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: TextField(
                        decoration: InputDecoration(hintText: "Board title"),
                        controller: _boardNameTextController,
                      ),
                    ),
                  ),
                  // Center(
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                  ),
                  //)
                ],
              ),
            ),
          );
        });
  }

  _addBoard(String boardName) {
    createBoard(window.localStorage['token'], boardName, "empty").then((response) => {
          if (response.statusCode == 201)
            {
              setState(() {
                _boardNameTextController.clear();
                boards.add(jsonDecode(response.body));
              })
            }
        });
  }
}

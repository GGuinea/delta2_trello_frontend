import 'dart:async';
import 'dart:convert';

import 'package:delta2_trello_frontend/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Board extends StatefulWidget {
  final String username;
  final int boardId;

  const Board({Key key, this.username, this.boardId}) : super(key: key);

  @override
  _BoardState createState() => _BoardState(username, boardId);
}

class _BoardState extends State<Board> {
  final String username;
  final int boardId;
  List<String> lists = ["List one", "List two"];
  List members = [];
  TextEditingController _listNameTextController = TextEditingController();
  TextEditingController _memberEmailTextController = TextEditingController();
  TextEditingController _descriptionController;
  TextEditingController _changeTextController;
  Timer searchOnStoppedTyping;
  String _boardName;
  String _description;
  bool viewVisible = false;
  double _menu = 0;
  bool firstFetch = true;

  _BoardState(this.username, this.boardId);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (firstFetch) _fetchMembers();
    _descriptionController = new TextEditingController(text: _description);

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
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 100),
                      child: IntrinsicWidth(
                        child: InkWell(
                          child: Text(
                            _boardName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onTap: () {
                            _showChangeBoardNameTextDialog();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Text(
                                          members[index]['username'],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            _deleteMember(members[index]['id']);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    )));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: RaisedButton(
                        onPressed: () {
                          _showCreateLinkDialog("https://deltatrello-11d65.firebaseapp.com/#/invite/" + username + "/" + _boardName);
                        },
                        textColor: Colors.black54,
                        color: Colors.white54,
                        hoverColor: Colors.lightGreenAccent,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text('Create a link', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                    //Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: RaisedButton(
                        onPressed: () {
                          _showAddMemberDialog();
                        },
                        textColor: Colors.black54,
                        color: Colors.white54,
                        hoverColor: Colors.lightGreenAccent,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text('Invite', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: RaisedButton(
                        onPressed: () {
                          if (viewVisible) {
                            setState(() {
                              viewVisible = false;
                              _menu = 0;
                            });
                          } else {
                            setState(() {
                              viewVisible = true;
                              _menu = 300;
                            });
                          }
                        },
                        textColor: Colors.black54,
                        color: Colors.white54,
                        hoverColor: Colors.lightGreenAccent,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text('Show menu', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height - 118,
                  width: size.width - _menu,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lists.length + 1,
                    itemBuilder: (context, index) {
                      if (index == lists.length)
                        return _buildAddListButton(context);
                      else
                        return _buildLists(context, index);
                    },
                  ),
                ),
                _buildMenu(context),
              ],
            ),
          ],
        ));
  }

  @override
  initState() {
    super.initState();
    fetchBoard();
  }

  fetchBoard() {
    getDetailsBoard(userToken, boardId).then((response) => {
          setState(() {
            _description = jsonDecode(response.body)['description'];
            _boardName = jsonDecode(response.body)['name'];
          }),
        });
  }

  Widget _buildLists(BuildContext context, int index) {
    return Container(
      width: 300.0,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              child: Text(
                lists[index],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _showChangeNameListTextDialog(lists[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildMenu(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 118,
      width: _menu,
      child: Visibility(
        visible: viewVisible,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          viewVisible = false;
                          _menu = 0;
                        });
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(
                      width: 90,
                    ),
                    Text("Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dashboard,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "About this board",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.teal)),
                              hintText: 'Enter details about board'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: new Text("Save"),
                            color: Colors.lightGreenAccent,
                            onPressed: () {
                              changeBoardDescription(userToken, _descriptionController.text, boardId)
                                  .then((response) => {
                                    if (response.statusCode == 202) {
                                      print("Description changed")
                                    }});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RaisedButton(
                    onPressed: () {
                      _showDialog();
                    },
                    textColor: Colors.black54,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white54),
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Delete board")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddListButton(context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            _showAddListDialog();
          },
          child: Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text("Add another list"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showAddListDialog() {
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
                        decoration: InputDecoration(hintText: "List title"),
                        controller: _listNameTextController,
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
                          if (_listNameTextController.text.trim() != "") {
                            Navigator.of(context).pop();
                            _addList(_listNameTextController.text.trim());
                          }
                        },
                        child: Text("Add list"),
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

  _addList(String listName) {
    lists.add(listName);
    _listNameTextController.clear();
    setState(() {});
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete this board ?", textAlign: TextAlign.center),
          actions: [
            FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                deleteBoard(userToken, boardId).then((response) => {
                      if (response.statusCode == 200) {Navigator.pushNamed(context, '/boards/'+username)}
                    });
              },
            ),
            FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showAddMemberDialog() {
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
                        decoration: InputDecoration(hintText: "User email"),
                        controller: _memberEmailTextController,
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
                          if (_memberEmailTextController.text.trim() != "") {
                            _addMember(_memberEmailTextController.text.trim());
                          }
                        },
                        child: Text("Add user"),
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

  _addMember(String email) {
    addMember(userToken, boardId, email).then((response) => {
          if (response.statusCode == 200)
            {
              setState(() {
                Navigator.of(context).pop();
                _memberEmailTextController.clear();
                _fetchMembers();
              })
            }
        });
  }

  _deleteMember(int userId) {
    deleteMember(userToken, boardId, userId).then((response) => {
          if (response.statusCode == 200) {_fetchMembers()}
        });
  }

  _fetchMembers() {
    getMembers(userToken, boardId).then((response) => {
          if (response.statusCode == 200)
            {
              members.clear(),
              members.addAll(jsonDecode(response.body)),
              firstFetch = false,
              setState(() {})
            }
        });
  }

  _showChangeNameListTextDialog(String text, int index) {
    TextEditingController _changeTextController = TextEditingController(text: text);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Change name list: '),
            content: TextField(
              controller: _changeTextController,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text("Sumbit"),
                onPressed: () {
                  setState(() {
                    lists[index] = _changeTextController.text;
                    print(_changeTextController.text + '  ' + index.toString());
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }

  _showChangeBoardNameTextDialog() {
    _changeTextController = new TextEditingController(text: _boardName);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Change board name : '),
            content: TextField(
              controller: _changeTextController,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text("Sumbit"),
                onPressed: () {
                  if(_changeTextController.text.isNotEmpty)
                  changeBoardName(userToken, _changeTextController.text, boardId)
                      .then((response) => {
                        if(response.statusCode == 202)
                            setState(() {
                              _boardName = _changeTextController.text;
                              Navigator.of(context).pop();
                            })
                          });
                },
              ),
            ],
          );
        });
  }
  _showCreateLinkDialog(String link) {
    _changeTextController = new TextEditingController(text: link);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Copy a link'),
            content: TextField(
              controller: _changeTextController,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

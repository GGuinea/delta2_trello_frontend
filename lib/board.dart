import 'dart:async';
import 'dart:convert';

import 'package:delta2_trello_frontend/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<String> lists = ["List one", "List two"];
  List members = [];
  TextEditingController _listNameTextController = TextEditingController();
  TextEditingController _memberEmailTextController = TextEditingController();
  TextEditingController descriptionController;
  Timer searchOnStoppedTyping;
  int _id;
  String _boardName;
  String _description;
  bool viewVisible = false;
  double _menu = 0;
  bool firstFetch = true;

  _onChangeHandler(name) {
    const duration = Duration(milliseconds: 1000);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel());
    }
    setState(() => searchOnStoppedTyping = new Timer(duration,
        () => name.toString().isNotEmpty
            ? changeBoardName(userToken, name, _id).then((response) => {
              if (response.statusCode == 202)
                _boardName = jsonDecode(response.body)['name']
            }) : print("Empty String")));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      _id = arguments['board']['id'];
      _boardName = arguments['board']['name'];

      if (firstFetch) _fetchMembers();
      getDetailsBoard(userToken, _id).then((response) => {
            _description = jsonDecode(response.body)['description'],
          });
    }
    descriptionController = new TextEditingController(text: _description);

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            initialValue: _boardName,
                            onChanged: _onChangeHandler,
                            decoration: new InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(blurRadius: 3, color: Colors.grey)
                                  ],
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
                      Spacer(),
                      RaisedButton(
                        onPressed: () {
                          _showAddMemberDialog();
                        },
                        textColor: Colors.black54,
                        color: Colors.white54,
                        hoverColor: Colors.lightGreenAccent,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text('Invite',
                              style: TextStyle(fontSize: 14)),
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
                          padding: const EdgeInsets.all(0.0),
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
                    height: size.height,
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
          ),
        ));
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
            child: Text(
              lists[index],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildMenu(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
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
                          controller: descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              hintText: 'Enter details about board'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: new Text("Save"),
                            color: Colors.lightGreenAccent,
                            onPressed: () {
                              changeBoardDescription(userToken, descriptionController.text, _id)
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
                deleteBoard(userToken, _id).then((response) => {
                      if (response.statusCode == 200) {Navigator.pushNamed(context, '/boards')}
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
    addMember(userToken, _id, email).then((response) => {
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

  _deleteMember(int userId){
    deleteMember(userToken, _id, userId).then((response) => {
      if (response.statusCode == 200)
        {
            _fetchMembers()
        }
    });
  }

  _fetchMembers() {
    getMembers(userToken, _id).then((response) => {
          if (response.statusCode == 200)
            {
              members.clear(),
              members.addAll(jsonDecode(response.body)),
              firstFetch = false,
              setState(() {})
            }
        });
  }
}

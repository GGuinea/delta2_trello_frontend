import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:delta2_trello_frontend/http_service.dart';
import 'package:delta2_trello_frontend/task_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';

class Board extends StatefulWidget {
  final String username;
  final int boardId;

  const Board({Key key, this.username, this.boardId}) : super(key: key);

  @override
  _BoardState createState() => _BoardState(username, boardId);
}

class Card {
  int id;
  String name;
  String deadline;
  String description;

  Card({this.id,this.name ,this.deadline,this.description});
}

class InnerList {
  int id;
  String name;
  List<Card> cards;

  InnerList({this.id, this.name, this.cards});
}

class _BoardState extends State<Board> {
  TextEditingController _listNameTextController = TextEditingController();
  TextEditingController _memberEmailTextController = TextEditingController();
  TextEditingController _descriptionController;
  TextEditingController _changeTextController;
  TextEditingController _cardTextController = TextEditingController();
  TextEditingController descriptionController;

  final String username;
  final int boardId;
  String _boardName = "";
  String _description = "";

  String _image = "";

  bool _firstFetch = true;
  List _members = [];
  List<InnerList> _lists = [];

  Timer searchOnStoppedTyping;
  bool viewVisible = false;
  double _menu = 0;

  @override
  void initState() {
    super.initState();

    fetchBoard();
    fetchLists();
  }

  _BoardState(this.username, this.boardId);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_firstFetch) _fetchMembers();
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                window.localStorage.remove('token');
                window.localStorage.remove('username');
                Navigator.pushNamed(context, "/");
              },
              iconSize: 32,
              tooltip: "Logout",
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_image),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
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
                            itemCount: _members.length,
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
                                            _members[index]['username'],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              _deleteMember(_members[index]['id']);
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
                            String encoded = base64.encode(utf8.encode(username + "/#/" + _boardName + "/#/" + boardId.toString() ));
                            _showCreateLinkDialog("https://deltatrello-11d65.firebaseapp.com/#/invite/" + encoded);
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
                      itemCount: _lists.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _lists.length)
                          return _buildAddListButton(context);
                        else
                          return _buildList(context, index);
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

  fetchBoard() {
    getDetailsBoard(window.localStorage['token'], boardId).then((response) => {
          if (response.statusCode == 200)
            {
              setState(() {
                _description = jsonDecode(response.body)['description'];
                _boardName = jsonDecode(response.body)['name'];
                _image += 'images/' + jsonDecode(response.body)['background_id'].toString() + '.jpg';
              }),
            }
          else
            {Navigator.pushNamed(context, '/404')}
        });
  }

  Widget _buildList(BuildContext context, int index) {
    return Stack(children: [
      Container(
        width: 300.0,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        margin: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Text(
                _lists[index].name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _showChangeNameListTextDialog(_lists[index].name, index);
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: DragAndDropList<Card>(
                _lists[index].cards,
                itemBuilder: (BuildContext context, item) {
                  return _buildCard(index, _lists[index].cards.indexOf(item));
                },
                onDragFinish: (oldIndex, newIndex) {
                  _onCardReorder(oldIndex, newIndex, index);
                },
              ),
            ),
            _buildAddCardWidget(context, index)
          ],
        ),
      ),
      Positioned.fill(
        child: DragTarget<dynamic>(
          onAccept: (data) {
            if (data['from'] == index) {
              return;
            }

            Card card = data['card'];

            updateCard(window.localStorage['token'], card.id, card.name,card.description,
                    card.deadline.toString(), _lists[index].id)
                .then((response) => {
                      if (response.statusCode == 202)
                        {
                          setState(() {
                            _lists[data['from']].cards.remove(data['card']);
                            _lists[index].cards.add(data['card']);
                          })
                        }
                    });
          },
          builder: (context, accept, reject) {
            return Container();
          },
        ),
      ),
    ]);
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
            child: ListView(
              scrollDirection: Axis.vertical,
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
                              changeBoardDescription(window.localStorage['token'],
                                      _descriptionController.text, boardId)
                                  .then((response) => {
                                        if (response.statusCode == 202)
                                          {print("Description changed")}
                                      });
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
                SizedBox(height: 10),
                Text("Wallpaper"),
                IconButton(
                  icon: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('images/0.jpg')),
                  iconSize: 200,
                  onPressed: () {
                    updateWallpaper(
                            window.localStorage['token'], boardId, "0")
                        .then((response) => {
                              if (response.statusCode == 202)
                                {
                                  setState(() {
                                    _image = "images/0.jpg";
                                  })
                                }
                            });
                  },
                ),
                IconButton(
                  icon: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('images/1.jpg')),
                  iconSize: 200,
                  onPressed: () {
                    updateWallpaper(
                        window.localStorage['token'], boardId, "1")
                        .then((response) => {
                      if (response.statusCode == 202)
                        {
                          setState(() {
                            _image = "images/1.jpg";
                          })
                        }
                    });
                  },
                ),IconButton(
                  icon: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('images/2.jpg')),
                  iconSize: 200,
                  onPressed: () {
                    updateWallpaper(
                        window.localStorage['token'], boardId, "2")
                        .then((response) => {
                      if (response.statusCode == 202)
                        {
                          setState(() {
                            _image = "images/2.jpg";
                          })
                        }
                    });
                  },
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
    addColumn(window.localStorage['token'], boardId, listName).then((response) => {
          if (response.statusCode == 201)
            {
              setState(() {
                InnerList innerList = new InnerList(
                  id:jsonDecode(response.body)['id'],
                  name: jsonDecode(response.body)['name'],
                  cards: List<Card>(),
                );
                _lists.add(innerList);
                _listNameTextController.clear();
              })
            }
        });
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
                deleteBoard(window.localStorage['token'], boardId).then((response) => {
                      if (response.statusCode == 200)
                        {Navigator.pushNamed(context, '/boards/' + username)}
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
    addMember(window.localStorage['token'], boardId, email).then((response) => {
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
    deleteMember(window.localStorage['token'], boardId, userId).then((response) => {
          if (response.statusCode == 200) {_fetchMembers()}
        });
  }

  _fetchMembers() {
    getMembers(window.localStorage['token'], boardId).then((response) => {
          if (response.statusCode == 200)
            {
              _members.clear(),
              _members.addAll(jsonDecode(response.body)),
              _firstFetch = false,
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
                child: new Text("Submit"),
                onPressed: () {
                  if (_changeTextController.text.isNotEmpty)
                    updateColumn(window.localStorage['token'], _changeTextController.text, _lists[index].id)
                        .then((response) => {
                              if (response.statusCode == 202)
                                setState(() {
                                  _lists[index].name = _changeTextController.text;
                                  Navigator.of(context).pop();
                                })
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
                child: new Text("Submit"),
                onPressed: () {
                  if (_changeTextController.text.isNotEmpty)
                    changeBoardName(
                            window.localStorage['token'], _changeTextController.text, boardId)
                        .then((response) => {
                              if (response.statusCode == 202)
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

  _onCardReorder(int oldCardIndex, int newCardIndex, int listIndex) {
    setState(() {
      var oldValue = _lists[listIndex].cards[oldCardIndex];
      _lists[listIndex].cards[oldCardIndex] = _lists[listIndex].cards[newCardIndex];
      _lists[listIndex].cards[newCardIndex] = oldValue;
    });
  }

  Widget _buildAddCardWidget(context, index) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            _showAddCardDialog(index);
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add,
              ),
              SizedBox(
                width: 16.0,
              ),
              Text("Add card"),
            ],
          ),
        ),
      ),
    );
  }

  _showAddCardDialog(int index) {
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
                          decoration: InputDecoration(hintText: "Card message"),
                          controller: _cardTextController,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: RaisedButton(
                            onPressed: () {
                              if (_cardTextController.text.trim() != "") {
                                _addCard(index, _cardTextController.text.trim());
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Add card"),
                          ),
                        ))
                  ],
                )),
          );
        });
  }

  _addCard(int index, String name) {
    addCard(window.localStorage['token'], _lists[index].id, name, "")
        .then((response) => {
              if (response.statusCode == 201)
                {
                  setState(() {
                    Card card = new Card(
                        id: jsonDecode(response.body)['id'],
                        name: jsonDecode(response.body)['name'],
                        description: jsonDecode(response.body)['description']);
                    _lists[index].cards.add(card);
                    _cardTextController.text = "";
                  })
                }
            });
  }

  Container _buildCard(int index, int innerIndex) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            width: 300.0,
            padding: const EdgeInsets.all(16.0),
            child: Text(_lists[index].cards[innerIndex].name),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(_lists[index].cards[innerIndex].name),
                  Spacer(),
                  Container(
                    width: 25,
                    child: TextButton(
                      onPressed: () {
                        _showEditCardDialog(index, innerIndex);
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: 25,
                    child: TextButton(
                      onPressed: () {
                        _deleteCard(index, innerIndex);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  if (_lists[index].cards[innerIndex].deadline == null)
                    Container()
                  else
                    Container(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(_lists[index].cards[innerIndex].deadline.substring(0, 10) + " " +
                              _lists[index].cards[innerIndex].deadline.substring(11, 16)),
                        )),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
        ),
        data: {"from": index, "card": _lists[index].cards[innerIndex]},
      ),
    );
  }

  _deleteCard(int listIndex, int cardIndex) {
    deleteCard(window.localStorage['token'], _lists[listIndex].cards[cardIndex].id)
        .then((response) => {
              if (response.statusCode == 200)
                {
                  setState(() {
                    _lists[listIndex].cards.removeAt(cardIndex);
                  })
                }
            });
  }

  fetchLists() {
    getLists(window.localStorage['token'], boardId).then((response) => {
          if (response.statusCode == 200)
            {
              setState(() {
                for (var listFromDatabase in jsonDecode(response.body)) {
                  InnerList innerList = new InnerList(
                      id: listFromDatabase['id'],
                      name: listFromDatabase['name'],
                      cards: List<Card>());

                  for (var cardFromDatabase in listFromDatabase['cards']) {
                    innerList.cards.add(new Card(
                        id: cardFromDatabase['id'],
                        name: cardFromDatabase['name'],
                        description: cardFromDatabase['description'].toString(),
                        deadline: cardFromDatabase['deadline']));
                  }
                  _lists.add(innerList);
                }
              })
            }
        });
  }

  void _showEditCardDialog(int index, int innerIndex) {
    _changeTextController =
        new TextEditingController(text: _lists[index].cards[innerIndex].name);
    TextEditingController _changeDescriptionTextController =
        new TextEditingController(text: _lists[index].cards[innerIndex].description);
    String deadline = _lists[index].cards[innerIndex].deadline;
    DateTime _dateTime;
    String data = "Choose date";
    String time = "Choose time";
    if (deadline != null) {
      _dateTime = DateTime.parse(deadline);
      data = _dateTime.toString().substring(0, 10);
      time = _dateTime.toString().substring(11, 16);
    }
    String error;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit card:'),
              content: Container(
                height: 600,
                child: Column(
                  children: [
                    Text(
                      "Card name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _changeTextController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Card description",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _changeDescriptionTextController,
                      maxLines: 4,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: 'Enter details about card'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Due Date",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: Text(data),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      data = value.toString().substring(0, 10);
                                      _dateTime = new DateTime(value.year, value.month, value.day);
                                      error = null;
                                    } else {
                                      data = "Choose date";
                                      time = "Choose time";
                                      _dateTime = null;
                                    }
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: Text(time),
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  setState(() {
                                    if (_dateTime == null) {
                                      error = "First choose Date";
                                    } else {
                                      if (value != null) {
                                        _dateTime = new DateTime(_dateTime.year, _dateTime.month,
                                            _dateTime.day, value.hour, value.minute);
                                        if (_dateTime.isBefore(DateTime.now())) {
                                          error = "Wrong time";
                                        } else {
                                          time = value.toString().substring(10, 15);
                                          error = null;
                                        }
                                      } else {
                                        time = "Choose time";
                                      }
                                    }
                                  });
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    error == null
                        ? Container()
                        : Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                    SizedBox(height: 10),
                    Text("Tasks"),
                    TaskListWidget(_lists[index].cards[innerIndex].id)
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _changeTextController.clear();
                  },
                ),
                FlatButton(
                  child: new Text("Submit"),
                  onPressed: () {
                    if (_changeTextController.text.isEmpty)
                      setState(() {
                        error = "Card must have name";
                      });
                    else
                      setState(() {
                        error = null;
                      });

                    if (data != "Choose date" && time == "Choose time")
                      setState(() {
                        error = "Choose time";
                      });
                    else if (error == null)
                      updateCard(window.localStorage['token'], _lists[index].cards[innerIndex].id,
                              _changeTextController.text,_changeDescriptionTextController.text, _dateTime.toString(), _lists[index].id)
                          .then((response) => {
                                if (response.statusCode == 202)
                                  setState(() {
                                    _lists[index].cards[innerIndex].name = _changeTextController.text;
                                    _lists[index].cards[innerIndex].description = _changeDescriptionTextController.text;
                                    _lists[index].cards[innerIndex].deadline = _dateTime.toString();
                                    if (_dateTime == null)
                                      _lists[index].cards[innerIndex].deadline = null;
                                    Navigator.of(context).pop();
                                    refreshView();
                                    _changeTextController.clear();
                                  })
                              });
                  },
                ),
              ],
            );
          });
        });
  }
  void refreshView(){
    setState(() {});
  }
}

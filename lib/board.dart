import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<String> lists = ["List one", "List two"];
  TextEditingController _listNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments as Map;
    //if (arguments != null) print(arguments['board']['id'].toString());

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
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lists.length + 1,
          itemBuilder: (context, index) {
            if (index == lists.length)
              return _buildAddListButton(context);
            else
              return _buildLists(context, index);
          },
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
            padding: const EdgeInsets.all(16.0),
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
            padding: EdgeInsets.all(16.0),
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
}

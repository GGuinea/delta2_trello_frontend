import 'dart:convert';
import 'dart:html';

import 'package:delta2_trello_frontend/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskListWidget extends StatefulWidget {
  final int cardId;

  TaskListWidget(this.cardId);

  @override
  State<StatefulWidget> createState() {
    return _TaskListWidgetState(cardId);
  }
}

class _TaskListWidgetState extends State<TaskListWidget> {
  TextEditingController _taskTextController = TextEditingController();
  List<Task> tasks = [];
  int cardId;

  _TaskListWidgetState(this.cardId);

  @override
  void initState() {
    super.initState();
    getTasks(window.localStorage['token'], cardId).then((response) => {
          if (response.statusCode == 200)
            {
              setState(() {
                for (var taskFromDatabase in jsonDecode(response.body)) {
                  Task task = Task(taskFromDatabase["id"],
                      taskFromDatabase["name"], taskFromDatabase["done"]);
                  tasks.add(task);
                }
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: tasks.length + 1,
        itemBuilder: (context, index) {
          if (index == tasks.length) {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Task message"),
                      controller: _taskTextController,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: RaisedButton(
                      onPressed: () {
                        if (_taskTextController.text.isNotEmpty) {
                          addTask(window.localStorage['token'], cardId,
                                  _taskTextController.text, false)
                              .then((response) => {
                                    if (response.statusCode == 201)
                                      {
                                        setState(() {
                                          _taskTextController.clear();
                                          tasks.add(Task(
                                              jsonDecode(response.body)['id'],
                                              jsonDecode(response.body)['name'],
                                              false));
                                        })
                                      }
                                  });
                        }
                      },
                      child: Text("Add task"),
                    ),
                  ),
                )
              ],
            );
          } else {
            return CheckboxListTile(
              title: Text(tasks[index].name),
              value: tasks[index].done,
              onChanged: (bool value) {
                updateTask(window.localStorage['token'], tasks[index].id,
                        tasks[index].name, value)
                    .then((response) => {
                          if (response.statusCode == 201)
                            {
                              setState(() {
                                tasks[index].done = value;
                              })
                            }
                        });

                setState(() {
                  tasks[index].done = value;
                });
              },
            );
          }
        },
      ),
    );
  }
}

class Task {
  int id;
  String name;
  bool done;

  Task(this.id, this.name, this.done);
}

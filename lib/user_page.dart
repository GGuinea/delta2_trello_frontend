import 'package:delta2_trello_frontend/data_model.dart';
import 'package:delta2_trello_frontend/http_service.dart';
import 'package:delta2_trello_frontend/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final HttpService httpService = HttpService();

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("There will be trello app here in the future!!"),
      ),
      body: FutureBuilder(
        future: httpService.getMessage(),
        builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
          if (snapshot.hasData) {
            Message message = snapshot.data;
            List<Data> data = message.data;
            return Scaffold(
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text(message.status),
                    Text(message.message),
                    for (var item in data)
                      Text(item.id.toString() +
                          ". " +
                          item.title +
                          " / " +
                          item.body +
                          " / " +
                          item.createdAt.toString() +
                          " / " +
                          item.updatedAt.toString())
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

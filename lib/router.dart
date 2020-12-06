import 'package:delta2_trello_frontend/boards.dart';
import 'package:delta2_trello_frontend/invite_page.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'home_page.dart';

class Routes {
  static void configureRoutes(fluro.Router router) {

    router.notFoundHandler = fluro.Handler(handlerFunc: (context, params) {
      debugPrint("ROUTE WAS NOT FOUND !!!");
      return RouteNotFound();
    });
    router.define(
      '/',
      handler: fluro.Handler(handlerFunc: (_, params) => HomePage()),
    );
    router.define(
      '/boards/:username',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        String username = params["username"]?.first;
        return Boards(username: username);
      }),
    );
    router.define(
      '/board/:username/:boardId',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        String username = params["username"]?.first;
        int boardId = int.parse(params["boardId"]?.first);
        return Board(username: username, boardId: boardId);
      }),
    );
    router.define(
      '/invite/:username/:boardName',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        String username = params["username"]?.first;
        String boardName = params["boardName"]?.first;
        boardName = boardName.replaceAll("%20", " ");
        return InvitePage(username: username, boardName: boardName);
      }),
    );
  }
}

class RouteNotFound extends StatelessWidget {
  const RouteNotFound({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          child: Text(
            '404',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}

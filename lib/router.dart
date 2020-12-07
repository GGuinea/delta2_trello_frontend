import 'dart:html';

import 'package:delta2_trello_frontend/boards.dart';
import 'package:delta2_trello_frontend/invite_page.dart';
import 'package:delta2_trello_frontend/page_not_found.dart';
import 'package:delta2_trello_frontend/user_logout_page.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'home_page.dart';

class Routes {
  static void configureRoutes(fluro.Router router) {
    router.notFoundHandler = fluro.Handler(handlerFunc: (context, params) {
      debugPrint("ROUTE WAS NOT FOUND !!!");
      return PageNotFound();
    });
    router.define(
      '/',
      handler: fluro.Handler(handlerFunc: (_, params) {
        if (window.localStorage['token'] != null && window.localStorage['username'] != null)
          return Boards(username: window.localStorage['username']);
        return HomePage();
      }),
    );
    router.define(
      '/boards/:username',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        if (window.localStorage['token'] == null) return LogoutUserPage();
        String username = params["username"]?.first;
        return Boards(username: username);
      }),
    );
    router.define(
      '/board/:username/:boardId',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        if (window.localStorage['token'] == null) return LogoutUserPage();
        String username = params["username"]?.first;
        int boardId = int.parse(params["boardId"]?.first);
        return Board(username: username, boardId: boardId);
      }),
    );
    router.define(
      '/invite/:username/:boardName',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        if (window.localStorage['token'] == null) return LogoutUserPage();
        String username = params["username"]?.first;
        String boardName = params["boardName"]?.first;
        boardName = boardName.replaceAll("%20", " ");
        return InvitePage(username: username, boardName: boardName);
      }),
    );
    router.define(
      '/404',
      transitionType: fluro.TransitionType.materialFullScreenDialog,
      handler: fluro.Handler(handlerFunc: (_, params) {
        return PageNotFound();
      }),
    );
  }
}


import 'package:delta2_trello_frontend/navigator.dart';
import 'package:delta2_trello_frontend/router.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = new fluro.Router();
  @override
  void initState() {
    Routes.configureRoutes(router);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      initialRoute: NavUtils.initialUrl,
      onGenerateRoute: router.generator,
    );
  }
}




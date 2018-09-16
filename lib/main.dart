import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/pages/HomePage.dart';
import 'package:fluro/fluro.dart';
import 'package:xcpilots/routes.dart';

class App{
  static Router router = Router();
}

void main() {
  defineRoutes(App.router);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
        runApp(XcPilotsApp());
    });
}

class XcPilotsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: translate('xc_pilots'),
      theme: new ThemeData(
        fontFamily: 'Nika',
        primarySwatch: Colors.blue,
      ),
      builder: (BuildContext context, Widget child) {
        return new Directionality(
          textDirection: TextDirection.rtl,
          child: new Builder(
            builder: (BuildContext context) {
              return new MediaQuery(
                data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                child: child,
              );
            },
          ),
        );
      },
      initialRoute: '/',
      home: HomePage(),
      routes: XcPilotsRoutes,
      onGenerateRoute: App.router.generator,
    );
  }
}


void defineRoutes(Router router) {
  router.define("/single_news/:newsId", handler: singleNewsHandler);
}


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:xcpilots/middlewares/new_middleware.dart';
import 'package:xcpilots/reducers/app_reducers.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/pages/HomePage.dart';
import 'package:fluro/fluro.dart';
import 'package:xcpilots/routes.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState(),
    middleware: []
      ..addAll(createNewsMiddlewares()),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: translate('xc_pilots'),
        theme: ThemeData(
          fontFamily: 'Nika',
          primarySwatch: Colors.blue,
        ),
        builder: (BuildContext context, Widget child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Builder(
              builder: (BuildContext context) {
                return MediaQuery(
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
      ),
    );
  }
}


void defineRoutes(Router router) {
  router.define("/single_news/:newsId", handler: singleNewsHandler);
}


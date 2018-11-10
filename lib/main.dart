import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:xcpilots/state/middlewares/background_middlewares.dart';
import 'package:xcpilots/state/middlewares/list_middleware.dart';
import 'package:xcpilots/state/reducers/app_reducers.dart';
import 'package:xcpilots/state/models/app_state.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/pages/HomePage.dart';
import 'package:fluro/fluro.dart';
import 'package:xcpilots/routes.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
 
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
  Persistor<AppState> persistor;
  Store<AppState> store;

  XcPilotsApp(){
    persistor = Persistor<AppState>(
      debug: true,
      storage: FlutterStorage("xcpilots"),
      decoder: AppState.fromJson,
    );
    store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: [persistor.createMiddleware()]
        ..addAll(createListMiddlewares())
        ..addAll(createBackgroundMiddlewares())
        ,
    );

    load(store);
  }

  Future<AppState> load(Store<AppState> store) async {
    try{
      return await persistor.load(store);
    }catch(err){
      await persistor.save(store);
      return await persistor.load(store);
    }
  } 
  
  @override
  Widget build(BuildContext context) {
    return PersistorGate(
      persistor: persistor,
        builder: (context) => StoreProvider<AppState>(
        store: store,
        child: createMaterial(),
      ),
    );
  }
}

Widget createMaterial(){
 return MaterialApp(
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
    routes: xcPilotsRoutes,
    onGenerateRoute: App.router.generator,
  );
}

void defineRoutes(Router router) {
  router.define("/single_news/:newsId", handler: singleNewsHandler);
}


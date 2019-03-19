import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:xcpilots/state/background/background_middlewares.dart';
import 'package:xcpilots/state/downloader.dart';
import 'package:xcpilots/state/list/list_middleware.dart';
import 'package:xcpilots/state/app_reducers.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/pages/HomePage.dart';
import 'package:fluro/fluro.dart';
import 'package:xcpilots/routes.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:xcpilots/state/top_flights/top_flights_actions.dart';
 
class App{
  static Router router = Router();
}

void main() {
  defineRoutes(App.router);
  // Persistor<AppState> persistor = Persistor<AppState>(
  //   debug: true,
  //   storage: FlutterStorage("xcpilots"),
  //   decoder: AppState.fromJson,
  // );
  Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(),
    middleware: []//persistor.createMiddleware()
      ..addAll(createListMiddlewares())
      ..addAll(createBackgroundMiddlewares())
      ..addAll(createDownloaderMiddlewares())
      ..addAll(createTopFlightsMiddlewares())
      ,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) {
      runApp(XcPilotsApp(store));
  });
}

class XcPilotsApp extends StatelessWidget {
  // final Persistor<AppState> persistor;
  final Store<AppState> store;

  XcPilotsApp(this.store){
    load(store);
  }

  Future<AppState> load(Store<AppState> store) async {
    // try{
    //   return await persistor.load(store);
    // }catch(err){
    //   await persistor.save(store);
    //   return await persistor.load(store);
    // }
  } 
  
  @override
  Widget build(BuildContext context) {
    // print('build xcpilots');
    return StoreProvider<AppState>(
      store: store,
      child: AppWidget(),
    );
    // return PersistorGate(
    //   persistor: persistor,
    //     builder: (context) => StoreProvider<AppState>(
    //     store: store,
    //     child: AppWidget(),
    //   ),
    // );
  }
}

class AppWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    // print('build app widget');
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
}

void defineRoutes(Router router) {
  router.define("/single_news/:newsId", handler: singleNewsHandler);
}


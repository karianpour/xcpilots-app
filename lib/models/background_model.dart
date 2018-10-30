import 'dart:ui';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/actions/background_actions.dart';
import 'package:xcpilots/models/app_state.dart';

StoreConverter<AppState, Map> backgroundFromStore(String section){
  return (Store<AppState> store) {
    Map background = store.state.state['background'];

//todo we have to check when we fetched last time, if it is older than 3 days, refetch it
    if(background==null || background[section]==null){
      print('no background, so refresh it');
      store.dispatch(new RefreshBackgroundAction(section));
      print('fetch dispatched');
      background = store.state.state['background'];
    }

    Map sectionBackground = Map<String, dynamic>.from(background[section]);

    sectionBackground['backgroundUrl'] = createBackgroundFunction(store, section, sectionBackground);

    return sectionBackground;
  };
}

Function createBackgroundFunction(Store<AppState> store, String section, Map sectionBackground){
  return () {
    if(sectionBackground['url']!=null) return sectionBackground['url'];

    if(!sectionBackground['fetching']){
      store.dispatch(new FetchBackgroundAction(section));
    }


  };
}
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/background_actions.dart';
import 'package:xcpilots/state/models/app_state.dart';

StoreConverter<AppState, Map> backgroundFromStore(String section){
  return (Store<AppState> store) {
    Map background = store.state.state['background'];

    if (background==null || background[section]==null) {
      print('no background for $section, so refresh it');
      store.dispatch(new RefreshBackgroundAction(section));
      background = store.state.state['background'];
    }

    Map sectionBackground = Map<String, dynamic>.from(background[section]);

    sectionBackground['backgroundUrl'] = createBackgroundFunction(store, section, sectionBackground);
    sectionBackground['firstFetch'] = createFirstFetchFunction(store, section);

    return sectionBackground;
  };
}

Function createBackgroundFunction(Store<AppState> store, String section, Map sectionBackground){
  return () {
    if(sectionBackground['url']!=null) return sectionBackground['url'];
  };
}

Function createFirstFetchFunction(Store<AppState> store, String section){
  return () {
    store.dispatch(FetchBackgroundAction(section));
  };
}

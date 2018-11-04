import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/background_actions.dart';
import 'package:xcpilots/state/models/app_state.dart';

const REFRESH_TIMEOUT = 1 * 24 * 60 * 60 * 1000;

StoreConverter<AppState, Map> backgroundFromStore(String section){
  return (Store<AppState> store) {
    Map background = store.state.state['background'];

    if(refreshBackground(background, section)){
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

bool refreshBackground(background, section) {
  if (background==null || background[section]==null) {
    print('background is null so refresh it');
    return true;
  }

  int lastTime = background[section]['lastTime'];
  if(lastTime==null) {
    print('background has not lastTime so refresh it');
    return true;
  }
  if(lastTime - DateTime.now().millisecondsSinceEpoch > REFRESH_TIMEOUT) {
    print('background is too old so refresh it');
    return true;
  }

  return false;
}
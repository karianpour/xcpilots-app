import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/background_actions.dart';
import 'package:xcpilots/state/models/app_state.dart';

const REFRESH_TIMEOUT = 1 * 24 * 60 * 60 * 1000;
const RETRY_TIMEOUT = 3 * 60 * 1000;

StoreConverter<AppState, Map> backgroundFromStore(String section){
  return (Store<AppState> store) {
    Map background = store.state.state['background'];

    bool needFirstFetch = false;

    if(refreshBackground(background, section)){
      print('no background, so refresh it');
      store.dispatch(new RefreshBackgroundAction(section));
      print('fetch dispatched');
      background = store.state.state['background'];
      needFirstFetch = true;
    }

    Map sectionBackground = Map<String, dynamic>.from(background[section]);

    if(refetchBackground(background, sectionBackground)){
      needFirstFetch = true;
    }

    if(needFirstFetch){
      store.dispatch(FetchBackgroundAction(section));
    }

    sectionBackground['backgroundUrl'] = createBackgroundFunction(store, section, sectionBackground);

    return sectionBackground;
  };
}

Function createBackgroundFunction(Store<AppState> store, String section, Map sectionBackground){
  return () {
    if(sectionBackground['url']!=null) return sectionBackground['url'];
  };
}

bool refreshBackground(background, section) {
  if (background==null || background[section]==null) {
    print('background is null so refresh it');
    return true;
  }

  return false;
}

bool refetchBackground(background, sectionBackground){
  int lastTime = sectionBackground['lastTime'];
  if(lastTime==null) {
    print('background has not lastTime so refresh it');
    return true;
  }

  if(lastTime - DateTime.now().millisecondsSinceEpoch > REFRESH_TIMEOUT) {
    print('background is too old so refresh it');
    return true;
  }

  if(sectionBackground['fetching'] && sectionBackground['lastTime'] - DateTime.now().millisecondsSinceEpoch > RETRY_TIMEOUT) {
    print('last try to fetch background is failed and is too old, so refetching');
    return true;
  }

  return false;
}

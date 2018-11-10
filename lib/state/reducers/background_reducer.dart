import 'package:xcpilots/state/actions/background_actions.dart';
import 'package:xcpilots/state/models/news_model.dart';

Map<String, dynamic> fetchBackground(Map<String, dynamic> state, FetchBackgroundAction action){
  state['background']['lastTime'] = DateTime.now().millisecondsSinceEpoch;
  return state;
}

Map<String, dynamic> refreshBackground(Map<String, dynamic> state, RefreshBackgroundAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newBackground = new Map<String, dynamic>.from(newState['background'] ?? {});
  newState['background'] = newBackground;

  Map<String, dynamic> newSection = {
    'lastTimeFailed': false,
    'fetching': false,
  };

  newBackground[action.section] = newSection;

  return newState;
}

Map<String, dynamic> fetchingBackground(Map<String, dynamic> state, BackgroundFetchingAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newBackground = new Map<String, dynamic>.from(newState['background'] ?? {});
  newState['background'] = newBackground;
  Map<String, dynamic> newSection = new Map<String, dynamic>.from(newBackground[action.section] ?? {});
  newBackground[action.section] = newSection;
  

  newSection['fetching'] = action.fetching;
  newSection['lastTimeFailed'] = false;
  newSection['lastTime'] = DateTime.now().millisecondsSinceEpoch;

  return newState;
}

Map<String, dynamic> fetchingBackgroundFailed(Map<String, dynamic> state, BackgroundFetchingFailedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newBackground = new Map<String, dynamic>.from(newState['background'] ?? {});
  newState['background'] = newBackground;
  Map<String, dynamic> newSection = new Map<String, dynamic>.from(newBackground[action.section] ?? {});
  newBackground[action.section] = newSection;

  newSection['lastTimeFailed'] = true;

  return newState;
}

Map<String, dynamic> fetchingBackgroundSucceed(Map<String, dynamic> state, BackgroundFetchingSucceedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newBackground = new Map<String, dynamic>.from(newState['background'] ?? {});
  newState['background'] = newBackground;
  Map<String, dynamic> newSection = new Map<String, dynamic>.from(newBackground[action.section] ?? {});
  newBackground[action.section] = newSection;

  newSection['lastTimeFailed'] = false;

  if(action.rows.length>0){
    print(action.rows[0]);
    newSection['url'] = findNewsImageUrl(action.rows[0]);
  }

  return newState;
}

import 'package:xcpilots/actions/news_actions.dart';


Map<String, dynamic> fetchingNews(Map<String, dynamic> state, NewsFetchingMoreRowsAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newNews = new Map<String, dynamic>.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['fetching'] = action.fetching;
  newNews['lastTimefailed'] = false;

  return newState;
}

Map<String, dynamic> fetchingNewsFailed(Map<String, dynamic> state, NewsFetchingMoreRowsFailedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newNews = new Map<String, dynamic>.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['lastTimefailed'] = true;

  return newState;
}

Map<String, dynamic> fetchingNewsSucceed(Map<String, dynamic> state, NewsFetchingMoreRowsSucceedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newNews = new Map<String, dynamic>.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['lastTimefailed'] = false;

  int _lastRowIndex = newNews['lastRowIndex'];
  Map<String, dynamic> rows = new Map<String, dynamic>.from(newNews['rows']);

  if(action.rows.length>0){
    var newDataStartIndex = _lastRowIndex==null ? 0 : _lastRowIndex + 1;
    _lastRowIndex = (_lastRowIndex == null ? -1 : _lastRowIndex) + action.rows.length;
    for(int i=0; i<action.rows.length; i++){
       final Map row = action.rows[i];
       rows[(newDataStartIndex + i).toString()] = row;
    }
    newNews['rows'] = rows;
    newNews['lastRowIndex'] = _lastRowIndex;
    newNews['rowQty'] = _lastRowIndex + 1 + 1;
  }else{
    newNews['noRowAvailable'] = true;
    newNews['rowQty'] = _lastRowIndex + 1;
  }

  return newState;
}

Map<String, dynamic> fetchNews(Map<String, dynamic> state, NewsFetchMoreRowsAction action){
  //Map newState = new Map.from(state);

  //newState['news']['list'] = ;

  return state;
}

Map<String, dynamic> refreshNews(Map<String, dynamic> state, NewsRefreshAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);

  Map<String, dynamic> newNews = {
    'rowQty': 0,
    'noRowAvailable': false,
    'lastTimeFailed': false,
    'lastRowIndex': null,
    'rows': <String, dynamic>{},
    'fetching': false,
    'scrollPosition': 0.0,
  };

  newState['news'] = newNews;

  return newState;
}

// Map saveScrollPosition(Map state, NewsSaveScrollPositionAction action){
//  Map newState = new Map.from(state);
//  Map newNews = new Map.from(newState['news'] ?? {});
//  newState['news'] = newNews;

//   newNews['scrollPosition'] = action.position;

//   return newState;
// }

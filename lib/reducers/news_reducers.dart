import 'package:xcpilots/actions/news_actions.dart';


Map fetchingNews(Map state, NewsFetchingMoreRowsAction action){
  Map newState = new Map.from(state);
  Map newNews = new Map.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['fetching'] = action.fetching;
  newNews['lastTimefailed'] = false;

  return newState;
}

Map fetchingNewsFailed(Map state, NewsFetchingMoreRowsFailedAction action){
  Map newState = new Map.from(state);
  Map newNews = new Map.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['lastTimefailed'] = true;

  return newState;
}

Map fetchingNewsSucceed(Map state, NewsFetchingMoreRowsSucceedAction action){
  Map newState = new Map.from(state);
  Map newNews = new Map.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['lastTimefailed'] = false;

  int _lastRowIndex = newNews['lastRowIndex'];
  Map rows = new Map.from(newNews['rows']);

  if(action.rows.length>0){
    var newDataStartIndex = _lastRowIndex==null ? 0 : _lastRowIndex + 1;
    _lastRowIndex = (_lastRowIndex == null ? -1 : _lastRowIndex) + action.rows.length;
    for(int i=0; i<action.rows.length; i++){
       final Map row = action.rows[i];
       rows[newDataStartIndex + i] = row;
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

Map fetchNews(Map state, NewsFetchMoreRowsAction action){
  //Map newState = new Map.from(state);

  //newState['news']['list'] = ;

  return state;
}

Map refreshNews(Map state, NewsRefreshAction action){
  Map newState = new Map.from(state);

  Map newNews = {
    'rowQty': 0,
    'noRowAvailable': false,
    'lastTimeFailed': false,
    'lastRowIndex': null,
    'rows': {},
    'fetching': false,
  };

  newState['news'] = newNews;

  return newState;
}

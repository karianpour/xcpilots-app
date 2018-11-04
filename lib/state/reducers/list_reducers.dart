import 'package:xcpilots/state/actions/list_actions.dart';


Map<String, dynamic> fetchingList(Map<String, dynamic> state, ListFetchingMoreRowsAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newNews = new Map<String, dynamic>.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['fetching'] = action.fetching;
  newNews['lastTimeFailed'] = false;

  return newState;
}

Map<String, dynamic> fetchingListFailed(Map<String, dynamic> state, ListFetchingMoreRowsFailedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newNews = new Map<String, dynamic>.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['lastTimeFailed'] = true;

  return newState;
}

Map<String, dynamic> fetchingListSucceed(Map<String, dynamic> state, ListFetchingMoreRowsSucceedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newNews = new Map<String, dynamic>.from(newState['news'] ?? {});
  newState['news'] = newNews;

  newNews['lastTimeFailed'] = false;

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

Map<String, dynamic> fetchList(Map<String, dynamic> state, ListFetchMoreRowsAction action){
  return state;
}

Map<String, dynamic> refreshList(Map<String, dynamic> state, ListRefreshAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);

  Map<String, dynamic> newNews = {
    'rowQty': 0,
    'noRowAvailable': false,
    'lastTimeFailed': false,
    'lastRowIndex': null,
    'rows': <String, dynamic>{},
    'fetching': false,
    'scrollPosition': 0.0,
    'refreshTime': DateTime.now().millisecondsSinceEpoch,
  };

  newState['news'] = newNews;

  return newState;
}

// Map saveScrollPosition(Map state, ListSaveScrollPositionAction action){
//  Map newState = new Map.from(state);
//  Map newNews = new Map.from(newState['news'] ?? {});
//  newState['news'] = newNews;

//   newNews['scrollPosition'] = action.position;

//   return newState;
// }

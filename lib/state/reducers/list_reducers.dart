import 'package:xcpilots/state/actions/list_actions.dart';


Map<String, dynamic> fetchingList(Map<String, dynamic> state, ListFetchingMoreRowsAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newList = new Map<String, dynamic>.from(newState[action.modelName] ?? {});
  newState[action.modelName] = newList;

  newList['fetching'] = action.fetching;
  newList['lastTimeFailed'] = false;
  newList['refreshTime'] = DateTime.now().millisecondsSinceEpoch;

  return newState;
}

Map<String, dynamic> fetchingListFailed(Map<String, dynamic> state, ListFetchingMoreRowsFailedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newList = new Map<String, dynamic>.from(newState[action.modelName] ?? {});
  newState[action.modelName] = newList;

  newList['lastTimeFailed'] = true;

  return newState;
}

Map<String, dynamic> fetchingListSucceed(Map<String, dynamic> state, ListFetchingMoreRowsSucceedAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newList = new Map<String, dynamic>.from(newState[action.modelName] ?? {});
  newState[action.modelName] = newList;

  newList['lastTimeFailed'] = false;

  int _lastRowIndex = action.firstFetch ? null : newList['lastRowIndex'];
  Map<String, dynamic> rows = action.firstFetch ? Map<String, dynamic>() : Map<String, dynamic>.from(newList['rows']);

  if(action.rows.length>0){
    var newDataStartIndex = _lastRowIndex==null ? 0 : _lastRowIndex + 1;
    _lastRowIndex = (_lastRowIndex == null ? -1 : _lastRowIndex) + action.rows.length;
    for(int i=0; i<action.rows.length; i++){
       final Map row = action.rows[i];
       rows[(newDataStartIndex + i).toString()] = row;
    }
    newList['rows'] = rows;
    newList['lastRowIndex'] = _lastRowIndex;
    newList['rowQty'] = _lastRowIndex + 1 + 1;
  }else{
    newList['noRowAvailable'] = true;
    newList['rowQty'] = _lastRowIndex + 1;
  }

  return newState;
}

Map<String, dynamic> fetchList(Map<String, dynamic> state, ListFetchMoreRowsAction action){
  state[action.modelName]['refreshTime'] = DateTime.now().millisecondsSinceEpoch;
  return state;
}

Map<String, dynamic> refreshList(Map<String, dynamic> state, ListRefreshAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);

  Map<String, dynamic> newList = {
    'rowQty': 0,
    'noRowAvailable': false,
    'lastTimeFailed': false,
    'lastRowIndex': null,
    'rows': <String, dynamic>{},
    'fetching': false,
    'scrollPosition': 0.0,
  };

  newState[action.modelName] = newList;

  return newState;
}

// Map saveScrollPosition(Map state, ListSaveScrollPositionAction action){
//  Map newState = new Map.from(state);
//  Map newList = new Map.from(newState[action.modelName] ?? {});
//  newState[action.modelName] = newList;

//   newList['scrollPosition'] = action.position;

//   return newState;
// }

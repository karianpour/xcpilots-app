import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/list_actions.dart';
import 'package:xcpilots/state/models/app_state.dart';

typedef void SaveScrollPosition(double position);
typedef void FetchMoreRows(bool firstFetch);

int counter = 0;

class ListModel {
  final int rowQty;
  final bool noRowAvailable;
  final bool lastTimeFailed;
  final int refreshTime;
  final int lastRowIndex;
  final Map rows;
  final bool fetching;
  final double scrollPosition;

  final Function refresh;
  final FetchMoreRows fetchMoreRows;
  final SaveScrollPosition saveScrollPosition;

  final ScrollController scrollController;

  ListModel({this.rowQty, this.noRowAvailable, this.lastTimeFailed, this.refreshTime, this.lastRowIndex, this.rows, this.fetching, this.scrollPosition, this.refresh, this.fetchMoreRows, this.saveScrollPosition, this.scrollController});

  static  listFromStore(String modelName){
    return (Store<AppState> store) => fromStore(store, modelName);
  }

  static ListModel fromStore(Store<AppState> store, String modelName){
    counter++;
    print("counter for ListModel $modelName : $counter");
    Map list = store.state.state[modelName];

    if(list==null){
      print('list is null so refresh it');
      store.dispatch(ListRefreshAction(modelName));
      list = store.state.state[modelName];
    }

    return ListModel(
      rowQty: list['rowQty'],
      noRowAvailable: list['noRowAvailable'],
      lastTimeFailed: list['lastTimeFailed'],
      refreshTime: list['refreshTime'],
      lastRowIndex: list['lastRowIndex'],
      rows: list['rows'],
      fetching: list['fetching'],
      scrollPosition: list['scrollPosition'],
      scrollController: ScrollController(initialScrollOffset: list['scrollPosition']),
      refresh: () {
        store.dispatch(new ListRefreshAction(modelName));
      },
      fetchMoreRows: (bool firstFetch) {
        store.dispatch(new ListFetchMoreRowsAction(modelName, firstFetch));
      },
      saveScrollPosition: (double position) {
        //store.dispatch(new NewsSaveScrollPositionAction(position));
        store.state.state[modelName]['scrollPosition'] = position;
      }
    );
  }
}

StoreConverter<AppState, Map> itemFromStore(String modelName, String id){
  return (Store<AppState> store) {
    Map list = store.state.state[modelName];
    Map rows = list['rows'];
    var key = rows.keys.firstWhere((k) => rows[k]['id']==id, orElse: () => null);
    return key == null ? null : rows[key];
  };
}



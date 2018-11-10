import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/list_actions.dart';
import 'package:xcpilots/state/models/app_state.dart';

typedef void SaveScrollPosition(double position);

int counter = 0;
const int REFRESH_TIMEOUT = 3 * 60 * 1000; // for test i reduced it  5 * 60 * 60 * 1000;

class ListModel {
  final int rowQty;
  final bool noRowAvailable;
  final bool lastTimeFailed;
  final int lastRowIndex;
  final Map rows;
  final bool fetching;
  final double scrollPosition;

  final VoidCallback refresh;
  final VoidCallback fetchMoreRows;
  final SaveScrollPosition saveScrollPosition;

  final ScrollController scrollController;

  ListModel({this.rowQty, this.noRowAvailable, this.lastTimeFailed, this.lastRowIndex, this.rows, this.fetching, this.scrollPosition, this.refresh, this.fetchMoreRows, this.saveScrollPosition, this.scrollController});

  static  listFromStore(String modelName){
    return (Store<AppState> store) => fromStore(store, modelName);
  }

  static ListModel fromStore(Store<AppState> store, String modelName){
    counter++;
    print("counter for ListModel $modelName : $counter");
    Map list = store.state.state[modelName];

    bool needFirstFetch = false;

    if(refreshList(list)){
      store.dispatch(ListRefreshAction(modelName));
      list = store.state.state[modelName];
      needFirstFetch = true;
    }

    if(refetchList(list)){
      needFirstFetch = true;
     }

    if(needFirstFetch && !list['fetching']){
      print('refetch fired');
      store.dispatch(ListFetchMoreRowsAction(modelName, true));
    }

    // //todo remove it

    // list = list ?? {
    //   'rowQty': 0,
    //   'noRowAvailable': false,
    //   'lastTimeFailed': false,
    //   'lastRowIndex': null,
    //   'rows': [],
    //   'fetching': false,
    // };
    return ListModel(
      rowQty: list['rowQty'],
      noRowAvailable: list['noRowAvailable'],
      lastTimeFailed: list['lastTimeFailed'],
      lastRowIndex: list['lastRowIndex'],
      rows: list['rows'],
      fetching: list['fetching'],
      scrollPosition: list['scrollPosition'],
      scrollController: ScrollController(initialScrollOffset: list['scrollPosition']),
      refresh: () {
        store.dispatch(new ListRefreshAction(modelName));
      },
      fetchMoreRows: () {
        store.dispatch(new ListFetchMoreRowsAction(modelName, false));
      },
      saveScrollPosition: (double position) {
        //store.dispatch(new NewsSaveScrollPositionAction(position));
        store.state.state[modelName]['scrollPosition'] = position;
      }
    );
  }

  static bool refreshList(Map list){
    if(list==null) {
      print('list is null so refresh it');
      return true;
    }
    if(list['refreshTime']==null) {
      print('refreshTime is null so refresh it');
      return true;
    }

    return false;
  }

  static bool refetchList(Map list){
    if(DateTime.now().millisecondsSinceEpoch - list['refreshTime'] > REFRESH_TIMEOUT) {
      print('timeout is passed so refresh it');
      return true;
    }

    return false;
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



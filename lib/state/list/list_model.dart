import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/list/list_actions.dart';
import 'package:xcpilots/state/app_state.dart';

typedef Future Refresh();
typedef void SaveScrollPosition(double position);
typedef void FetchMoreRows(bool firstFetch);
typedef void DispatchAction(dynamic action);

int counter = 0;

class ListModel {
  final String modelName;
  final int rowQty;
  final bool noRowAvailable;
  final bool lastTimeFailed;
  final int refreshTime;
  final int lastRowIndex;
  final Map rows;
  final bool fetching;
  final double scrollPosition;

  final Refresh refresh;
  final FetchMoreRows fetchMoreRows;
  final SaveScrollPosition saveScrollPosition;
  final DispatchAction dispatch;

  final ScrollController scrollController;

  ListModel({this.modelName, this.rowQty, this.noRowAvailable, this.lastTimeFailed, this.refreshTime, this.lastRowIndex, this.rows, this.fetching, this.scrollPosition, this.refresh, this.fetchMoreRows, this.saveScrollPosition, this.dispatch, this.scrollController});

  static listFromStore(String modelName){
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
      modelName: modelName,
      rowQty: list['rowQty'],
      noRowAvailable: list['noRowAvailable'],
      lastTimeFailed: list['lastTimeFailed'],
      refreshTime: list['refreshTime'],
      lastRowIndex: list['lastRowIndex'],
      rows: list['rows'],
      fetching: list['fetching'],
      scrollPosition: list['scrollPosition'],
      scrollController: ScrollController(initialScrollOffset: list['scrollPosition']),
      refresh: () async {
        store.dispatch(ListRefreshAction(modelName));
      },
      fetchMoreRows: (bool firstFetch) {
        store.dispatch(ListFetchMoreRowsAction(modelName, firstFetch));
      },
      saveScrollPosition: (double position) {
        // TODO it should not dispatch, it should save the position some where that we can load later before we load the list
        // it can be done via state persisting process, and also updated directly on the state, not via dispatch.
        // store.dispatch(ListSaveScrollPositionAction(modelName, position));
      },
      dispatch: (dynamic action) {
        store.dispatch(action);
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



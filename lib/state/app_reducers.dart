import 'package:redux_persist/redux_persist.dart';
import 'package:xcpilots/state/background/background_actions.dart';
import 'package:xcpilots/state/list/list_actions.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:xcpilots/state/list/list_reducers.dart';
import 'package:xcpilots/state/background/background_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    state: doAction(state.state, action),
  );
}

Map<String, dynamic> doAction(Map state, action){
  if (action is PersistLoadedAction<AppState>) {
    // Load to state
    return action.state !=null ? action.state.state : state;
  }else if(action is PersistErrorAction){
    return <String, dynamic>{};
  }else if(action is ListFetchMoreRowsAction){
    return fetchList(state, action);
  }else if(action is ListFetchingMoreRowsAction){
    return fetchingList(state, action);
  }else if(action is ListFetchingMoreRowsFailedAction){
    return fetchingListFailed(state, action);
  }else if(action is ListFetchingMoreRowsSucceedAction){
    return fetchingListSucceed(state, action);
  }else if(action is ListRefreshAction){
    return refreshList(state, action);
  }else if(action is ListSaveScrollPositionAction){
    return saveScrollPosition(state, action);
  }else if(action is RefreshBackgroundAction){
    return refreshBackground(state, action);
  }else if(action is FetchBackgroundAction){
    return fetchBackground(state, action);
  }else if(action is BackgroundFetchingAction){
    return fetchingBackground(state, action);
  }else if(action is BackgroundFetchingFailedAction){
    return fetchingBackgroundFailed(state, action);
  }else if(action is BackgroundFetchingSucceedAction){
    return fetchingBackgroundSucceed(state, action);
  }
  return state;
}
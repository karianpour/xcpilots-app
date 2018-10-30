import 'package:redux_persist/redux_persist.dart';
import 'package:xcpilots/actions/background_actions.dart';
import 'package:xcpilots/actions/news_actions.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:xcpilots/reducers/news_reducers.dart';
import 'package:xcpilots/reducers/background_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    state: doAction(state.state, action),
  );
}

doAction(Map state, action){
  if (action is PersistLoadedAction<AppState>) {
    // Load to state
    return action.state !=null ? action.state.state : state;
  }else if(action is PersistErrorAction){
    return {};
  }else if(action is NewsFetchMoreRowsAction){
    return fetchNews(state, action);
  }else if(action is NewsFetchingMoreRowsAction){
    return fetchingNews(state, action);
  }else if(action is NewsFetchingMoreRowsFailedAction){
    return fetchingNewsFailed(state, action);
  }else if(action is NewsFetchingMoreRowsSucceedAction){
    return fetchingNewsSucceed(state, action);
  }else if(action is NewsRefreshAction){
    return refreshNews(state, action);
  // }else if(action is NewsSaveScrollPositionAction){
  //   return saveScrollPosition(state, action);
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
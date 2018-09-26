import 'package:redux_persist/redux_persist.dart';
import 'package:xcpilots/actions/news_actions.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:xcpilots/reducers/news_reducers.dart';

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
    return state;
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
  }
  return state;
}
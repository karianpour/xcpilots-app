import 'package:xcpilots/actions/news_actions.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:xcpilots/reducers/news_reducers.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    state: doAction(state.state, action),
  );
}

doAction(Map state, action){
  if(action is NewsFetchMoreRowsAction){
    return fetchNews(state, action);
  }else if(action is NewsFetchingMoreRowsAction){
    return fetchingNews(state, action);
  }else if(action is NewsFetchingMoreRowsFailedAction){
    return fetchingNewsFailed(state, action);
  }else if(action is NewsFetchingMoreRowsSucceedAction){
    return fetchingNewsSucceed(state, action);
  }else if(action is NewsRefreshAction){
    return refreshNews(state, action);
  }
  return state;
}
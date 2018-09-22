import 'package:redux/redux.dart';
import 'package:xcpilots/actions/news_actions.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/models/app_state.dart';

List<Middleware<AppState>> createNewsMiddlewares(){

  return [
    new TypedMiddleware<AppState, NewsFetchMoreRowsAction>(_fetchMoreRows()),
  ];
}


Middleware<AppState> _fetchMoreRows(){
  return (Store store, action, NextDispatcher next) async{
    Map state = store.state.state;
    if(state['news'] != null && state['news']['fetching']) return;

    store.dispatch(new NewsFetchingMoreRowsAction(true));

    String before;
    Map _cachedRows = state['news']['rows'];
    int _lastRowIndex = state['news']['lastRowIndex'];

    if(_cachedRows != null && _lastRowIndex != null && _lastRowIndex >= 0){
      before = _cachedRows[_lastRowIndex]['created_at'];
      print('fetching before $before');
    }else{
      print('first time fetch');
    }
  

    try{
      List rows = await XcPilotsApi.getInstance().fetchNewsData(modelName: 'news', before: before);
      store.dispatch(new NewsFetchingMoreRowsSucceedAction(rows));
    }catch(error){
      store.dispatch(new NewsFetchingMoreRowsFailedAction());
      print(error);
    } finally {
      store.dispatch(new NewsFetchingMoreRowsAction(false));
      print('end fetching');
    }

    next(action);
  };
}
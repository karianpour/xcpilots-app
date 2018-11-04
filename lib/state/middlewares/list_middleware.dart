import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/list_actions.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/state/models/app_state.dart';

List<Middleware<AppState>> createListMiddlewares(){
  return [
    new TypedMiddleware<AppState, ListFetchMoreRowsAction>(_fetchMoreRows()),
  ];
}

Middleware<AppState> _fetchMoreRows(){
  return (Store store, action, NextDispatcher next) async{
    Map state = store.state.state;
    String modelName = action.modelName;
    if(state[modelName] != null && state[modelName]['fetching']) return;

    store.dispatch(new ListFetchingMoreRowsAction(modelName, true));

    String before;
    Map<String, dynamic> _cachedRows = state[modelName]['rows'];
    int _lastRowIndex = state[modelName]['lastRowIndex'];

    if(_cachedRows != null && _lastRowIndex != null && _lastRowIndex >= 0){
      before = _cachedRows[_lastRowIndex.toString()]['created_at'];
      print('fetching before $before');
    }else{
      print('first time fetch');
    }
  

    try{
      List rows = await XcPilotsApi.getInstance().fetchNewsData(modelName: modelName, before: before);
      store.dispatch(new ListFetchingMoreRowsSucceedAction(modelName, rows));
    }catch(error){
      store.dispatch(new ListFetchingMoreRowsFailedAction(modelName));
      print(error);
    } finally {
      store.dispatch(new ListFetchingMoreRowsAction(modelName, false));
      print('end fetching');
    }

    next(action);
  };
}
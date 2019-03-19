import 'package:redux/redux.dart';
import 'package:xcpilots/state/list/list_actions.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/state/app_state.dart';

List<Middleware<AppState>> createListMiddlewares(){
  return [
    new TypedMiddleware<AppState, ListFetchMoreRowsAction>(_fetchMoreRows()),
  ];
}

Middleware<AppState> _fetchMoreRows(){
  return (Store store, action, NextDispatcher next) async{
    if(action is ListFetchMoreRowsAction){
      Map state = store.state.state;
      String modelName = action.modelName;

      store.dispatch(ListFetchingMoreRowsAction(modelName, true));

      String before;
      Map<String, dynamic> _cachedRows = state[modelName]['rows'];
      int _lastRowIndex = state[modelName]['lastRowIndex'];

      if(!action.firstFetch && _cachedRows != null && _lastRowIndex != null && _lastRowIndex >= 0){
        before = _cachedRows[_lastRowIndex.toString()]['created_at'];
        print('fetching before $before');
      }else{
        print('first time fetch');
      }
    

      try{
        List rows = await XcPilotsApi.getInstance().fetchData(modelName: modelName, before: before);
        store.dispatch(ListFetchingMoreRowsSucceedAction(modelName, rows, action.firstFetch));
      }catch(error){
        store.dispatch(ListFetchingMoreRowsFailedAction(modelName));
        print(error);
      } finally {
        store.dispatch(ListFetchingMoreRowsAction(modelName, false));
        print('end fetching');
      }
    }
    next(action);
  };
}
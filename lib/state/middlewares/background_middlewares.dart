import 'package:redux/redux.dart';
import 'package:xcpilots/state/actions/background_actions.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/state/models/app_state.dart';

List<Middleware<AppState>> createBackgroundMiddlewares(){
  return [
    new TypedMiddleware<AppState, FetchBackgroundAction>(_fetchBackground()),
  ];
}

Middleware<AppState> _fetchBackground(){
  return (Store store, action, NextDispatcher next) async{
    Map state = store.state.state;
    if(state['background'] != null){
      if(state['background'][action.section] != null) {
        if(state['background'][action.section]['fetching'] != null){
          if(state['background'][action.section]['fetching']){
            return;
          }
        } 
      } 
    } 
//todo we have to put also the time and if it is too long we have to try again
    store.dispatch(new BackgroundFetchingAction(action.section, true));

    try{
      List rows = await XcPilotsApi.getInstance().fetchBackground(section: action.section);
      store.dispatch(new BackgroundFetchingSucceedAction(action.section, rows));
    }catch(error){
      store.dispatch(new BackgroundFetchingFailedAction(action.section));
      print(error);
    } finally {
      store.dispatch(new BackgroundFetchingAction(action.section, false));
      print('end fetching');
    }

    next(action);
  };
}
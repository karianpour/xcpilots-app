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
    store.dispatch(new BackgroundFetchingAction(action.section, true));

    try{
      List rows = await XcPilotsApi.getInstance().fetchBackground(section: action.section);
      store.dispatch(BackgroundFetchingSucceedAction(action.section, rows));
    }catch(error){
      store.dispatch(BackgroundFetchingFailedAction(action.section));
      print(error);
    } finally {
      store.dispatch(BackgroundFetchingAction(action.section, false));
      print('end fetching');
    }

    next(action);
  };
}
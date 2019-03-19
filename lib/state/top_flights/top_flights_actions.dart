import 'package:redux/redux.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/state/app_state.dart';

List<Middleware<AppState>> createTopFlightsMiddlewares(){
  return [
    new TypedMiddleware<AppState, FetchTopFlightsAction>(_fetchTopFlights()),
  ];
}

class InitiateTopFlightsAction {
  InitiateTopFlightsAction();
}

class FetchTopFlightsStateAction {
  final bool fetching;

  FetchTopFlightsStateAction({this.fetching});
}

class FetchTopFlightsAction {
  FetchTopFlightsAction();
}

class FetchTopFlightsDoneAction {
  final Map topFlights;
  final bool succeed;

  FetchTopFlightsDoneAction({this.topFlights, this.succeed});
}

Middleware<AppState> _fetchTopFlights(){
  return (Store store, action, NextDispatcher next) async{
    if(action is FetchTopFlightsAction){
      store.dispatch(FetchTopFlightsStateAction(fetching: true));

      try{
        Map topFlights = await XcPilotsApi.getInstance().fetchTopFlights();
        store.dispatch(FetchTopFlightsDoneAction(topFlights: topFlights, succeed: true));
      }catch(error){
        store.dispatch(FetchTopFlightsDoneAction(succeed: true));
        print(error);
      }
    }

    next(action);
  };
}
import 'package:xcpilots/state/top_flights/top_flights_actions.dart';
import 'package:xcpilots/state/top_flights/top_flights_model.dart';


Map<String, dynamic> initiateTopFlightsState(Map<String, dynamic> state, InitiateTopFlightsAction action){
  Map<String, dynamic> newState = Map<String, dynamic>.from(state);

  Map<String, dynamic> newList = {
    'fetching': false,
    'fetched': false,
    'lastTimeFailed': false,
    'refreshTime': null,
    'scrollPosition': 0.0,
    'categories' : <String, dynamic>{}    
  };
  newState[TopFlightsStateName] = newList;

  return newState;
}

Map<String, dynamic> fetchTopFlightsState(Map<String, dynamic> state, FetchTopFlightsStateAction action){
  Map<String, dynamic> newState = Map<String, dynamic>.from(state);
  Map<String, dynamic> newList = Map<String, dynamic>.from(newState[TopFlightsStateName] ?? {});
  newState[TopFlightsStateName] = newList;

  newList['fetching'] = action.fetching;
  if(action.fetching) newList['lastTimeFailed'] = false;
  newList['refreshTime'] = DateTime.now().millisecondsSinceEpoch;

  return newState;
}

Map<String, dynamic> fetchTopFlights(Map<String, dynamic> state, FetchTopFlightsDoneAction action){
  Map<String, dynamic> newState = Map<String, dynamic>.from(state);
  Map<String, dynamic> newList = Map<String, dynamic>.from(newState[TopFlightsStateName] ?? {});
  newState[TopFlightsStateName] = newList;

  newList['fetching'] = false;
  newList['fetched'] = true;
  if(action.succeed) {
    newList['lastTimeFailed'] = false;
    newList['categories'] = action.topFlights;
  }else{
    newList['lastTimeFailed'] = true;
  }
  newList['refreshTime'] = DateTime.now().millisecondsSinceEpoch;

  return newState;
}

import 'package:xcpilots/state/top_flights/top_flights_model.dart';

const REFRESH_TIMEOUT = 1 * 60 * 60 * 1000;
const RETRY_TIMEOUT = 3 * 60 * 1000;

void manageTopFlights(TopFlightsModel topFlights) async{
  bool needFirstFetch = false;

  if(isRefetchTopFlightsNeeded(topFlights)){
    needFirstFetch = true;
  }

  if(needFirstFetch){
    topFlights.refresh();
  }
}

bool isRefetchTopFlightsNeeded(TopFlightsModel topFlights){
  int refreshTime = topFlights.refreshTime;
  if(refreshTime==null) {
    print('top flights has not refreshTime so refresh it');
    return true;
  }

  if(DateTime.now().millisecondsSinceEpoch - refreshTime > REFRESH_TIMEOUT) {
    print('top flights is too old so refresh it');
    return true;
  }

  if(topFlights.fetching && DateTime.now().millisecondsSinceEpoch - topFlights.refreshTime > RETRY_TIMEOUT) {
    print('last try to fetch top flights is failed and is too old, so refetching');
    return true;
  }

  return false;
}

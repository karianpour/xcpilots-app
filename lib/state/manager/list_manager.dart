import 'package:xcpilots/state/models/list_model.dart';

const int REFRESH_TIMEOUT = 60 * 60 * 1000;
const RETRY_TIMEOUT = 3 * 60 * 1000;

void manageList(ListModel list) async{
    bool needFirstFetch = false;

    if(refetchList(list)){
      needFirstFetch = true;
     }

    if(needFirstFetch){
      print('refetch fired');
      list.fetchMoreRows(true);
    }
}

bool refetchList(ListModel list){
  int lastTime = list.refreshTime;
  if(lastTime==null) {
    print('refreshTime is null so refresh it');
    return true;
  }
  if(DateTime.now().millisecondsSinceEpoch - lastTime > REFRESH_TIMEOUT) {
    print('list is too old so refresh it');
    return true;
  }
  if(list.fetching && DateTime.now().millisecondsSinceEpoch - lastTime > RETRY_TIMEOUT) {
    print('last try to fetch the list is failed and is too old, so refetching');
    return true;
  }

  return false;
}

const REFRESH_TIMEOUT = 1 * 60 * 60 * 1000;
const RETRY_TIMEOUT = 3 * 60 * 1000;

void manageBackground(Map sectionBackground) async{
  bool needFirstFetch = false;

  if(refetchBackground(sectionBackground)){
    needFirstFetch = true;
  }

  if(needFirstFetch){
    sectionBackground['firstFetch']();
  }
}

bool refetchBackground(sectionBackground){
  int lastTime = sectionBackground['lastTime'];
  if(lastTime==null) {
    print('background has not lastTime so refresh it');
    return true;
  }

  if(DateTime.now().millisecondsSinceEpoch - lastTime > REFRESH_TIMEOUT) {
    print('background is too old so refresh it');
    return true;
  }

  if(sectionBackground['fetching'] && DateTime.now().millisecondsSinceEpoch - sectionBackground['lastTime'] > RETRY_TIMEOUT) {
    print('last try to fetch background is failed and is too old, so refetching');
    return true;
  }

  return false;
}

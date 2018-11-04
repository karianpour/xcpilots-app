import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/lib/jalali.dart';
import 'package:xcpilots/utils.dart';

String getNewsTitle(data){
  if(data==null) return '';
  // var title = "${data['id']} ${data['title']==null?'':data['title']}";
  var title = data['title']==null?'':data['title'];
  return title;
}

String getNewsTime(data){
  if(data==null) return '';
  var timestamp = data['created_at'];
  if(timestamp==null) return '';
  PersianDate date = new PersianDate.fromGregorianString(timestamp);
  final formatted = date.toString(showTime: true);
  //print(formatted);
  final converted = formatted.replaceAllMapped(RegExp(r"\d"), 
    (Match m) {
      return convertDigit(m[0]);
    }
  );
  //print(converted);
  return translate('publish_time') +' \u200e'+ converted;
}

String getNewsDescription(data){
  if(data==null) return '';
  return data['description']==null?'':data['description'];
}

String getNewsBody(data){
  if(data==null) return '';
  return data['body']!=null?data['body']:data['description']!=null?data['description']:'';
}


String findNewsImageUrl(Map data) {
  if(data==null) return null;
  var images = data['pictures'];
  if(images!=null && images is List){
    if(images.length>0){
      if(images[0]['thumbnail']!=null)
        return getPicturesBaseUrl() + images[0]['thumbnail'];
      else if(images[0]['url']!=null)
        return getPicturesBaseUrl() + images[0]['url'];
      else if(images[0]['src']!=null)
        return getPicturesBaseUrl() + images[0]['src'];
    }
  }
  return null;
}

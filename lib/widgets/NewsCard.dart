import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jalali_date/jalali_date.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/data/translation.dart';
//import 'package:transparent_image/transparent_image.dart';
import 'package:xcpilots/utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image/network.dart';  

class NewsCard extends StatelessWidget {

  final Map data;
  final int index;

  NewsCard(this.data, this.index);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(3.0),
      onPressed: () {
        String route = '/single_news/$index';
        Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 4.0/3.0,
                      child: buildNewsImage(data)
                    ),
                    Text(
                      getNewsTitle(data),
                      textAlign: TextAlign.start,
                      style: DefaultTextStyle.of(context).style.apply(
                        fontSizeFactor: 1.5).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(getNewsDescription(data), 
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}


final double imageSize = 160.0;

Widget buildNewsImage(data){
  var url = findNewsImageUrl(data);
  if(url!=null){
    // return CachedNetworkImage(
    //   placeholder: CircularProgressIndicator(),
    //   imageUrl: url,
    //   errorWidget: new Icon(Icons.error),
    // );
    // return FadeInImage.memoryNetwork(
    //             placeholder: kTransparentImage,
    //             image: url,
    //                // 'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
    //           );
    // return Image.network(url, fit: BoxFit.fitWidth,);
    print(url);
    return FadeInImage(
            placeholder: AssetImage('assets/images/loading.gif'),
            image: NetworkImageWithRetry(url),
            fit: BoxFit.fitWidth,
          );
  }else{
    return Icon(Icons.photo_camera, size: imageSize);
  }
}

String getNewsTitle(data){
  var title = data['title']==null?'':data['title'];
  return title;
}

String getNewsTime(data){
  var timestamp = data['timestamp'];
  if(timestamp==null) return '';
  PersianDate date = new PersianDate.fromGregorianString(timestamp);
  final formatted = date.toString(showTime: true);
  print(formatted);
  final converted = formatted.replaceAllMapped(RegExp(r"\d"), 
    (Match m) {
      return convertDigit(m[0]);
    }
  );
  print(converted);
  return translate('publish_time') +' \u200e'+ converted;
}

String getNewsDescription(data){
  return data['description']==null?'':data['description'];
}

String getNewsBody(data){
  return data['body']!=null?data['body']:data['description']!=null?data['description']:'';
}


String findNewsImageUrl(Map data) {
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
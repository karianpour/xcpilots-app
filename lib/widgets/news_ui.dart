import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xcpilots/state/news/news_model.dart';

class NewsCard extends StatelessWidget {

  final Map data;
  final int index;

  NewsCard(this.data, this.index);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(3.0),
      onPressed: () {
        if(data["id"]==null) return;
        String route = '/single_news/${data["id"]}';
        Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 4.0/3.0,
                      child: buildNewsImage(data)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getNewsTitle(data),
                        textAlign: TextAlign.start,
                        style: DefaultTextStyle.of(context).style.apply(
                          fontSizeFactor: 1.5).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getNewsDescription(data), 
                        textAlign: TextAlign.start,
                      ),
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
    // print(url);
    // return FadeInImage(
    //         placeholder: AssetImage('assets/images/loading.gif'),
    //         image: NetworkImageWithRetry(url),
    //         fit: BoxFit.fitWidth,
    //       );
    return FadeInImage(
            placeholder: AssetImage('assets/images/loading.gif'),
            image: CachedNetworkImageProvider(url),
            fit: BoxFit.fitWidth,
          );
  }else{
    return Icon(Icons.photo_camera, size: imageSize);
  }
}
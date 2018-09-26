import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/actions/news_actions.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/lib/jalali.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:xcpilots/utils.dart';

typedef void SaveScrollPosition(double position);

int counter = 0;

class NewsListModel {
  final int rowQty;
  final bool noRowAvailable;
  final bool lastTimeFailed;
  final int lastRowIndex;
  final Map rows;
  final bool fetching;
  final double scrollPosition;

  final VoidCallback refresh;
  final VoidCallback fetchMoreRows;
  final SaveScrollPosition saveScrollPosition;

  final ScrollController scrollController;

  NewsListModel({this.rowQty, this.noRowAvailable, this.lastTimeFailed, this.lastRowIndex, this.rows, this.fetching, this.scrollPosition, this.refresh, this.fetchMoreRows, this.saveScrollPosition, this.scrollController});

  static NewsListModel fromStore(Store<AppState> store){
    counter++;
    print(counter);
    Map news = store.state.state['news'];

    if(news==null){
      store.dispatch(new NewsRefreshAction());
      news = store.state.state['news'];
    }

    // //todo remove it

    // news = news ?? {
    //   'rowQty': 0,
    //   'noRowAvailable': false,
    //   'lastTimeFailed': false,
    //   'lastRowIndex': null,
    //   'rows': [],
    //   'fetching': false,
    // };
    return NewsListModel(
      rowQty: news['rowQty'],
      noRowAvailable: news['noRowAvailable'],
      lastTimeFailed: news['lastTimeFailed'],
      lastRowIndex: news['lastRowIndex'],
      rows: news['rows'],
      fetching: news['fetching'],
      scrollPosition: news['scrollPosition'],
      scrollController: ScrollController(initialScrollOffset: news['scrollPosition']),
      refresh: () {
        store.dispatch(new NewsRefreshAction());
      },
      fetchMoreRows: () {
        store.dispatch(new NewsFetchMoreRowsAction());
      },
      saveScrollPosition: (double position) {
        //store.dispatch(new NewsSaveScrollPositionAction(position));
        store.state.state['news']['scrollPosition'] = position;
      }
    );
  }
}

StoreConverter<AppState, Map> newsFromStore(String newsId){
  return (Store<AppState> store) {
    Map news = store.state.state['news'];
    Map rows = news['rows'];
    var key = rows.keys.firstWhere((k) => rows[k]['id']==newsId, orElse: () => null);
    return key == null ? null : rows[key];
  };
}


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

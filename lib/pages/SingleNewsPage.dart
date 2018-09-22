import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xcpilots/data/mock/news.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/models/news_model.dart';
import 'package:xcpilots/widgets/NewsCard.dart';

class SingleNewsPage extends StatefulWidget {
  final String newsId;

  const SingleNewsPage({Key key, this.newsId}) : super(key: key);

  @override
  _SingleNewsPageState createState() => new _SingleNewsPageState();
}

class _SingleNewsPageState extends State<SingleNewsPage> {

  Map data;

  _SingleNewsPageState(){
  }

  Future<Null> _handleRefresh() async{
    setState(() {
       data['body'] = 'dkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfgdkgadlfkkjhgdf kjghadf akjfghald kjfhgadl kjfhgdl kfjghld kfjghslfk jghsgjkl shf glkjshfglk jshfgks jfhgs kjfhgls kfjghls kfjghsl kfjghls kjfhgls kjfghls kfjghsf lkgjshgl ksjhfgl ksjfhgls kjfghls kfjghslfkjghsl fkjghsl fkjghsfgkl jsfg';
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    data = sampleNews;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('single_news_page_title')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        child: SafeArea(
          child: _buildView(context, data),
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }
}

_buildView(BuildContext context, Map data){
  return Container(
    constraints: BoxConstraints.expand(),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildNewsImage(data),
                  Text(
                    getNewsTitle(data),
                    textAlign: TextAlign.start,
                  ),
                  Text(getNewsBody(data), 
                    textAlign: TextAlign.start,
                  ),
                  Text(getNewsTime(data), 
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

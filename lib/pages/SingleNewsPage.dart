import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:xcpilots/state/news/news_model.dart';
import 'package:xcpilots/state/list/list_model.dart';
import 'package:xcpilots/widgets/news_ui.dart';

class SingleNewsPage extends StatelessWidget {
  final String newsId;

  const SingleNewsPage({Key key, this.newsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map>(
        converter: itemFromStore('news', newsId),
        builder: (BuildContext context, Map data) {
          return Scaffold(
          appBar: AppBar(
            title: Text(translate('single_news_page_title')),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  String route = '/';
                  // Navigator.pushNamed(context, route);
                  Navigator.popUntil(context, ModalRoute.withName(route));
                  // Navigator.pop(context);
                },
              )
            ],
          ),
          body: SafeArea(
            child: _buildView(context, data, newsId),
          ),
        );
      }
    );
  }
}

_buildView(BuildContext context, Map data, String newsId){
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getNewsTitle(data),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(getNewsBody(data), 
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(getNewsTime(data), 
                      textAlign: TextAlign.end,
                    ),
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

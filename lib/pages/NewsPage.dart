import 'package:flutter/material.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/widgets/news_ui.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('news_page_title')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: NewsList(),
    );
  }
}

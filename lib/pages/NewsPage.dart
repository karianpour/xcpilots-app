import 'package:flutter/material.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/widgets/news_ui.dart';

class NewsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('news_page_title')),
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
      body: NewsList(),
    );
  }
}

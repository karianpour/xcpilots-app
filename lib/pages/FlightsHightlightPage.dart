import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xcpilots/data/translation.dart';

class FlightsHighlightPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('flights_highlight')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              String route = '/';
              Navigator.popUntil(context, ModalRoute.withName(route));
            },
          )
        ],
      ),
      body: _aboutUs(context)
    );
  }
}

_aboutUs(BuildContext context) {
  final mediaQueryData = MediaQuery.of(context);
  final double topPadding = mediaQueryData.size.height > 600 ? mediaQueryData.size.height - 600 : 0;
  const double imagePadding = 80.0; //mediaQueryData.size.width / 4;
  return Container(
    constraints: BoxConstraints.expand(),
    child: ListView(
      padding: EdgeInsets.only(top: topPadding),
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Icon(Icons.build, size: 80.0,),
              Text(translate('flights_highlight')),
              Text('Here we want to show the best flights done in the last week/month/year/ever done in iran/world'),
            ],
          ),
        ),
        Placeholder(),
      ],
    ),
  );
}


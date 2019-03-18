import 'package:flutter/material.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/widgets/list_ui.dart';
import 'package:xcpilots/widgets/content_ui.dart';

class ContentPage extends StatelessWidget {
  final String _title;
  final String _modelName;

  ContentPage(this._title, this._modelName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(_title)),
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
      
      body: InfinitList(_modelName, (map, index, listModel){
        return ContentCard(map, index, listModel);
      }),
    );
  }
}

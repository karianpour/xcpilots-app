import 'package:flutter/material.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/widgets/top_flights_ui.dart';

class TopFlightsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('top_flights')),
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
      body: TopFlights()
    );
  }
}

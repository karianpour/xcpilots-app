import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xcpilots/data/translation.dart';

class AboutUsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('about_us_title')),
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
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 50.0),
          child: Padding(
            padding: const EdgeInsets.only(left: imagePadding, right: imagePadding, bottom: 10.0),
            child: Image(image: AssetImage('assets/images/XcBowo.jpg'), fit: BoxFit.fitWidth,),
          )),
        Center(
          child: Column(
            children: <Widget>[
              Text(translate('about_us_content')),
              Text('Kayvan Arianpour'),
              Text('Sadegh Barikani'),
              Text('Mohammad Azari'),
              Text('Matin Firoozi'),
              Text('Bowo'),
            ],
          ),
        ),
      ],
    ),
  );
}


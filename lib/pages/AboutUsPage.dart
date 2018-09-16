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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
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
    decoration: BoxDecoration(
      image:
          DecorationImage(
            image: AssetImage('assets/images/xcpilots_bg.jpeg'),
            fit: BoxFit.cover
          ),
    ),
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
          child: Text(translate('about_us_content')),
        ),
        Placeholder(),
      ],
    ),
  );
}


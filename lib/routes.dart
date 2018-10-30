import 'package:xcpilots/pages/AboutUsPage.dart';
import 'package:xcpilots/pages/FlightsHightlightPage.dart';
import 'package:xcpilots/pages/GlideMagazinePage.dart';
import 'package:xcpilots/pages/IranXcPage.dart';
import 'package:xcpilots/pages/NewsPage.dart';
import 'package:xcpilots/pages/RadioParagliderPage.dart';
import 'package:xcpilots/pages/SingleNewsPage.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

final Map<String, WidgetBuilder> xcPilotsRoutes = {
  '/news': (context) => NewsPage(),
  '/about_us': (context) => AboutUsPage(),
  '/flights_highlight': (context) => FlightsHighlightPage(),
  '/radio_paraglider': (context) => RadioParagliderPage(),
  '/glide_magazine': (context) => GlideMagazinePage(),
  '/iran_xc': (context) => IranXcPage(),
};

var singleNewsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return SingleNewsPage(newsId: params['newsId'][0]);
  }
);


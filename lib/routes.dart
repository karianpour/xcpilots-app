import 'package:xcpilots/pages/AboutUsPage.dart';
import 'package:xcpilots/pages/TopFlightsPage.dart';
import 'package:xcpilots/pages/GlideMagazinePage.dart';
import 'package:xcpilots/pages/NewsPage.dart';
import 'package:xcpilots/pages/RadioParagliderPage.dart';
import 'package:xcpilots/pages/SingleNewsPage.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

final Map<String, WidgetBuilder> xcPilotsRoutes = {
  '/news': (context) => NewsPage(),
  '/about_us': (context) => AboutUsPage(),
  '/top_flights': (context) => TopFlightsPage(),
  '/radio_paraglider': (context) => RadioParagliderPage(),
  '/glide_magazine': (context) => GlideMagazinePage(),
};

var singleNewsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return SingleNewsPage(newsId: params['newsId'][0]);
  }
);


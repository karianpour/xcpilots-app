import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xcpilots/XcPilotsTheme.dart';
import 'package:xcpilots/data/translation.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled=false;
    debugPaintPointersEnabled=false;
    debugPaintLayerBordersEnabled=false;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('xc_pilots')),
      ),
      body: _dashboard(context),
    );
  }
}

_dashboard(BuildContext context) {
  final mediaQueryData = MediaQuery.of(context);
  final double topPadding = mediaQueryData.size.height > 600 ? mediaQueryData.size.height - 600 : 0;
//  const double imagePadding = 80.0; //mediaQueryData.size.width / 4;
  return Container(
    constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(
      image:
          DecorationImage(
            image: AssetImage('assets/images/xcpilots_bg.jpeg'),
            fit: BoxFit.cover
          ),
    ),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            height: topPadding,
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Image(image: AssetImage('assets/images/XcBowo.jpg'), fit: BoxFit.fitWidth,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
            child: HomeOptions(),
          ),
        ],
      ),
    ),
  );
}

class HomeOptions extends StatelessWidget {
  const HomeOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DashboardOption(title: translate('news'), route: '/news', image: 'iranxc_news.jpeg'),
              DashboardOption(title: translate('glide'), route: '/glide_magazine'),
              DashboardOption(title: translate('radio_paraglider'), route: '/radio_paraglider'),
              DashboardOption(title: translate('iranxc'), route: '/iran_xc'),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DashboardOption(title: translate('flights_hightligh'), route: '/flights_highlight'),
              DashboardOption(title: translate('about_us'), route: '/about_us'),
            ],
          ),
        ),
      ],
    );
  }
}

class DashboardOption extends StatelessWidget {
  final String title;
  final String route;
  final String image;

  const DashboardOption({Key key, this.title, this.route, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        child: buildChild(),
        color: ButtonColor,
        onPressed: () {
          // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  Widget buildChild(){
    if(image!=null){
      return Column(
        children: <Widget>[
          Image(image: AssetImage('assets/images/$image'), fit: BoxFit.fitWidth),
          Text(title),
        ],
      );
    }else{
      return Text(title);
    }
  }
}

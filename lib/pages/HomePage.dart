import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter_image/network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xcpilots/state/background/background_manager.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:xcpilots/XcPilotsTheme.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/state/background/background_model.dart';

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
  final double topPadding = mediaQueryData.size.height > 280 ? mediaQueryData.size.height - 280 : 0;
//  const double imagePadding = 80.0; //mediaQueryData.size.width / 4;
    return StoreConnector<AppState, Map>(
    		// Build a viewModel, as usual:
        converter: backgroundFromStore('home'),
        builder: (BuildContext context, Map vm) {
          manageBackground(vm);
          String backgroundUrl = vm['backgroundUrl']();

          return Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image:
                  backgroundUrl == null ? 
                  DecorationImage(
                    image: AssetImage('assets/images/xcp.png'),
                    fit: BoxFit.contain
                  )
                  : 
                  DecorationImage(
                    //image: NetworkImageWithRetry(backgroundUrl), //AssetImage('assets/images/xcpilots_bg.jpeg'),
                    image: CachedNetworkImageProvider(backgroundUrl),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                    child: HomeOptions(),
                  ),
                ],
              ),
            ),
          );
        });
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
              DashboardOption(title: translate('news'), route: '/news'),
              DashboardOption(title: translate('glide'), route: '/glide_magazine'),
              DashboardOption(title: translate('radio_paraglider'), route: '/radio_paraglider'),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DashboardOption(title: translate('top_flights'), route: '/top_flights'),
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

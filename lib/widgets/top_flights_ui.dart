import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xcpilots/data/translation.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:xcpilots/state/top_flights/top_flights_manager.dart';
import 'package:xcpilots/state/top_flights/top_flights_model.dart';
import 'package:xcpilots/utils.dart';
import 'package:xcpilots/widgets/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

Timer _debounce;

class TopFlights extends StatelessWidget {

  // final ScrollController _scrollController = ScrollController();

  TopFlights(){
    // _scrollController.addListener((){
    //   print('position: ${_scrollController.position}');
    // });
  }

  _handleScrollPositionChanged(TopFlightsModel vm, double position) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      vm.saveScrollPosition(position);
    });
  }

  Widget _buildList(TopFlightsModel topFlights){
    return NotificationListener(
      onNotification: (notifiction){
        if(notifiction is ScrollNotification){
          _handleScrollPositionChanged(topFlights, notifiction.metrics.pixels);
        }
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(5.0),
        controller: topFlights.scrollController,

        itemCount: topFlights.categories.length,

        itemBuilder: (context, index) {
          Category category = topFlights.categories[index];
          return _buildCategory(category, context);
        },
      ),
    );
  }

  _buildCategory(Category category, BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
        color: Colors.black12,
      ),
      child: Column(
        children: <Widget>[
          Text(translate(category.name), style: Theme.of(context).textTheme.headline),
          Container(
            child: Column(
              children: 
                category.flights == null ? 
                  Text('empty')
                : category.flights.map((f) {
                return Container(
                  margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.black38),
                    borderRadius: BorderRadius.all(Radius.elliptical(30, 15)),
                    color: Colors.black26,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(translate('flight_date') + ' :'),
                          Text('\u200e' + mapToFarsi(f.flightDate.toString(showTime: true))),
                          Expanded(
                            flex: 1,
                            child: Text(translate('points') + ' :', textAlign: TextAlign.end,)
                          ),
                          Text(
                            mapToFarsi(f.flightPoints.toString()),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(translate('point_name') + ' :'),
                          Text(f.pilotName),
                          Expanded(
                            flex: 1,
                            child: Text(translate('site_name') + ' :', textAlign: TextAlign.end),
                          ),
                          Text(f.siteName +' - '+ f.siteCountry),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(translate('glider_name') + ' :'),
                          Text(f.glider),
                          Expanded(
                            flex: 1,
                            child: Text(translate('glider_class') + ' :', textAlign: TextAlign.end,)
                          ),
                          Text(f.gliderClass),
                        ],
                      ),
                      RaisedButton(
                        child: Text(translate('show_flihgt')),
                        onPressed: (){
                          openXContest(f.flightUrl);
                        },
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TopFlightsModel>(
    		// Build a viewModel, as usual:
        converter: TopFlightsModel.fromStore,
        builder: (BuildContext context, TopFlightsModel vm) {
          manageTopFlights(vm);
          if(vm.categories == null && vm.lastTimeFailed)
            return buildFailed(vm.refresh);
          else if(vm.categories == null && (vm.fetching || !vm.fetched))
            return buildLoading();
          else if(vm.categories == null)
            return buildEmptyPlaceHolder(vm.refresh);
          else
            return RefreshIndicator(
              child: SafeArea(
                  child: _buildList(vm),
              ),
              onRefresh: tryToRefresh(vm),
            );
        });
  }
}

Function tryToRefresh(TopFlightsModel vm) {
  return () async {
    if(await isOnline()){
      vm.refresh();
    }
  };
}

void openXContest(String url) async {
  final completeUrl = url.startsWith('http') ? url : 'http://www.xcontest.org' + url;
  print(completeUrl);
  if (await canLaunch(completeUrl)) {
    await launch(completeUrl);
  } else {
    throw 'Could not launch $completeUrl';
  }
}
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/lib/jalali.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:xcpilots/state/top_flights/top_flights_actions.dart';

const TopFlightsStateName = 'topFlights';

typedef Future Refresh();
typedef void SaveScrollPosition(double position);

int counter = 0;

class TopFlightsModel {
  final Map data;

  final Refresh refresh;
  final SaveScrollPosition saveScrollPosition;

  final ScrollController scrollController;

  TopFlightsModel({this.data, this.refresh, this.saveScrollPosition, this.scrollController});

  static TopFlightsModel fromStore(Store<AppState> store){
    counter++;
    print("counter for TopFlightsModel : $counter");
    Map data = store.state.state[TopFlightsStateName];

    if(data==null){
      print('data is null so refresh it');
      store.dispatch(InitiateTopFlightsAction());
      data = store.state.state[TopFlightsStateName];
    }

    return TopFlightsModel(
      data: data,
      scrollController: ScrollController(initialScrollOffset: data == null || data['scrollPosition'] == null ? 0.0 : data['scrollPosition']),
      refresh: () async {
        store.dispatch(FetchTopFlightsAction());
      },
      saveScrollPosition: (double position) {
        // TODO it should not dispatch, it should save the position some where that we can load later before we load the list
        // it can be done via state persisting process, and also updated directly on the state, not via dispatch.
        // store.dispatch(TopFlightsSaveScrollPositionAction(modelName, position));
      },
    );
  }

  bool get fetching => data['fetching'];
  bool get fetched => data['fetched'];
  bool get lastTimeFailed => data['lastTimeFailed'];
  int get refreshTime => data['refreshTime'];
  List<Category> get categories => data == null || data['categories'] == null ? null : CategoryNames.where( (c) => data['categories'][c] != null ).map<Category>( (c) => Category(c, data['categories'][c]) ).toList();
}

const List<String> CategoryNames = [
  'the_best_ir_7',
  'the_best_ir_30',
  'the_best_ir',
  'the_best_all_7',
  'the_best_all_30',
  'the_best_all',
];

class Category {
  final String name;
  final List<Flight> flights;

  Category(this.name, List<dynamic> data): this.flights = data?.map<Flight>( (d) => Flight(d) )?.toList();
}

class Flight {
  final dynamic data;

  Flight(this.data);

  String get id => data['id'];
  String get flightId => data['flight_id'];
  String get scope => data['scope'];
  PersianDate get flightDate => PersianDate.fromGregorianString(data['flight_date']);
  String get pilotCountry => data['pilot_country'];
  String get pilotName => data['pilot_name'];
  String get siteCountry => data['site_country'];
  String get siteName => data['site_name'];
  String get flightType => data['flight_type'];
  double get flightLength => data['flight_length'].toDouble();
  String get flightLengthUnit => data['flight_length_unit'];
  double get flightPoints => data['flight_points'].toDouble();
  String get flightUrl => data['flight_url'];
  String get glider => data['glider'];
  String get gliderClass => data['glider_class'];
}
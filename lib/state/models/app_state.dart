import 'dart:convert';

class AppState {
  final Map<String, dynamic> state;

  AppState({this.state = const {}});

	@override
	String toString() {
		return 'AppState : ${json.encode(state)}';
	}

  static AppState fromJson(dynamic json) {
      sanitizeLists(json);
      AppState(state: json);
  }

  static dynamic sanitizeLists(dynamic state) {
    if(state['news']!=null){
      state['news']['fetching'] = false;
    }
  }

  dynamic toJson() => state;
}
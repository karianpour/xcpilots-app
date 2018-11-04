import 'dart:convert';

class AppState {
  final Map<String, dynamic> state;

  AppState({this.state = const {}});

	@override
	String toString() {
		return 'AppState : ${json.encode(state)}';
	}

  static AppState fromJson(dynamic json) =>
      AppState(state: json);

  dynamic toJson() => state;
}
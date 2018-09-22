import 'dart:convert';

class AppState {
  final Map state;

  AppState({this.state = const {}});

	@override
	String toString() {
		return 'AppState : ${json.encode(state)}';
	}
}
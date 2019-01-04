class BackgroundFetchingAction {
  final String _section;
  final bool _fetching;

  BackgroundFetchingAction(this._section, this._fetching);

  bool get fetching => _fetching;
  String get section => _section;
}

class BackgroundFetchingFailedAction {
  final String _section;

  BackgroundFetchingFailedAction(this._section);

  String get section => _section;
}

class BackgroundFetchingSucceedAction {
  final String _section;
  final List _rows;

  BackgroundFetchingSucceedAction(this._section, this._rows);

  List get rows => _rows;
  String get section => _section;
}

class FetchBackgroundAction {
  final String _section;

  FetchBackgroundAction(this._section);

  String get section => _section;
}

class RefreshBackgroundAction {
  final String _section;

  RefreshBackgroundAction(this._section);

  String get section => _section;
}


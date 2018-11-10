class ListFetchingMoreRowsAction {
  final String _modelName;
  final bool _fetching;

  ListFetchingMoreRowsAction(this._modelName, this._fetching);

  bool get fetching => _fetching;
  String get modelName => _modelName;
}

class ListFetchingMoreRowsFailedAction {
  final String _modelName;

  ListFetchingMoreRowsFailedAction(this._modelName);

  String get modelName => _modelName;
}

class ListFetchingMoreRowsSucceedAction {
  final String _modelName;
  final List _rows;
  final bool _firstFetch;

  ListFetchingMoreRowsSucceedAction(this._modelName, this._rows, this._firstFetch);

  List get rows => _rows;
  String get modelName => _modelName;
  bool get firstFetch => _firstFetch;
}

class ListFetchMoreRowsAction {
  final String _modelName;
  final bool _firstFetch;

  ListFetchMoreRowsAction(this._modelName, this._firstFetch);

  String get modelName => _modelName;
  bool get firstFetch => _firstFetch;
}

class ListRefreshAction {
  final String _modelName;

  ListRefreshAction(this._modelName);

  String get modelName => _modelName;
}

// class ListSaveScrollPositionAction {
//  final String _modelName;
//   final double _position;

//   ListSaveScrollPositionAction(this._modelName, this._position);

//   double get position => _position;
//  String get modelName => _modelName;
// }


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

  ListFetchingMoreRowsSucceedAction(this._modelName, this._rows);

  List get rows => _rows;
  String get modelName => _modelName;
}

class ListFetchMoreRowsAction {
  final String _modelName;

  ListFetchMoreRowsAction(this._modelName);

  String get modelName => _modelName;
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


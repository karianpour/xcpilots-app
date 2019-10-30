import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:xcpilots/state/list/list_actions.dart';

List<Middleware<AppState>> createDownloaderMiddlewares(){
  return [
    new TypedMiddleware<AppState, DownloadFileAction>(_downloadFile()),
    new TypedMiddleware<AppState, DeleteFileAction>(_deleteFile()),
    new TypedMiddleware<AppState, ListFetchingMoreRowsSucceedAction>(_setupAlreadyDownloadedFiles()),
  ];
}

class DownloadFileAction {
  final String _modelName;
  final String _id;
  final String _directory;
  final String _fileName;
  final int _fileSize;
  final String _url;

  DownloadFileAction(this._modelName, this._id, this._directory, this._fileName, this._fileSize, this._url);

  String get modelName => _modelName;
  String get id => _id;
  String get directory => _directory;
  String get fileName => _fileName;
  int get fileSize => _fileSize;
  String get url => _url;
}

class DeleteFileAction {
  final String _modelName;
  final String _id;
  final String _fileName;

  DeleteFileAction(this._modelName, this._id, this._fileName);

  String get modelName => _modelName;
  String get id => _id;
  String get fileName => _fileName;
}

class DownloadFileStateAction {
  final String _modelName;
  final String _id;
  final bool _downloading;
  final bool _downloaded;
  final int _received;
  
  DownloadFileStateAction(this._modelName, this._id, this._downloading, this._downloaded, this._received);

  String get modelName => _modelName;
  String get id => _id;
  bool get downloading => _downloading;
  bool get downloaded => _downloaded;
  int get received => _received;
}

Map<String, dynamic> downloadFile(Map<String, dynamic> state, DownloadFileAction action){
  // state[action.modelName]['refreshTime'] = DateTime.now().millisecondsSinceEpoch;
  return state;
}

Map<String, dynamic> deleteFile(Map<String, dynamic> state, DeleteFileAction action){
  // state[action.modelName]['refreshTime'] = DateTime.now().millisecondsSinceEpoch;
  return state;
}

Map<String, dynamic> downloadFileState(Map<String, dynamic> state, DownloadFileStateAction action){
  Map<String, dynamic> newState = new Map<String, dynamic>.from(state);
  Map<String, dynamic> newList = new Map<String, dynamic>.from(newState[action.modelName] ?? {});
  newState[action.modelName] = newList;

  var rows = newList['rows'];
  var key = rows.keys.firstWhere((k) => rows[k]['id']==action.id, orElse: () => null);
  if(key!=null){
    var newRow = Map.from(newList['rows'][key]);
    if(action.downloading!=null) newRow['downloading'] = action.downloading;
    if(action.downloaded!=null) newRow['downloaded'] = action.downloaded;
    if(action.received!=null) newRow['received'] = action.received;
    newList['rows'][key] = newRow;
  }

  
  return newState;
}

Map<String, _DownLoadProcess> downlodProcesses = {};

class _DownLoadProcess {
  final String _modelName;
  final String _id;
  final CancelToken _cancelToken;

  _DownLoadProcess(this._modelName, this._id, this._cancelToken);

  String get modelName => _modelName;
  String get id => _id;
  CancelToken get cancelToken => _cancelToken;
}

Middleware<AppState> _downloadFile(){
  return (Store store, action, NextDispatcher next) async{
    if(action is DownloadFileAction){
      String modelName = action.modelName;
      String id = action.id;
      String fileName = action.fileName;
      int fileSize = action.fileSize;
      String url = action.url;
      String directory = modelName;
      print("data $fileName $url");

      store.dispatch(DownloadFileStateAction(modelName, action.id, true, false, 0));

      try{
        //TODO move this part to api classes
        var dio = new Dio();
        //dio.options.baseUrl = "http://xcpilots.karianpour.ir/";
        dio.options.connectTimeout = 5000;
        dio.options.receiveTimeout=5000;

        final documentsDir = await getApplicationDocumentsDirectory();

        var dir = Directory('${documentsDir.path}/$directory');

        await dir.create(recursive: true);

        String path = '${dir.path}/$fileName';
        print('downloading from $url to $path');

        var cancelToken = new CancelToken();
        downlodProcesses['$modelName.$id'] = _DownLoadProcess(modelName, id, cancelToken);

        const String BASE_URL = 'http://xcpilots.karianpour.ir';
        Response response = await dio.download(
            '$BASE_URL$url', path, cancelToken: cancelToken, onReceiveProgress: (received, total) {

          var state = store.state.state[modelName];
          var key = state['rows'].keys.firstWhere((k) => state['rows'][k]['id']==id, orElse: () => null);
          if(key != null && received!=null){
            int prevReceived = state['rows'][key]['received'];
            if(prevReceived==null) prevReceived = 0;
            // if( (received - prevReceived) / state['rows'][key]['file']['size'] > 0.05 ) {
            if( (received - prevReceived) > (200 * 1024) ) {
              print('$received,$fileSize');
              store.dispatch(DownloadFileStateAction(modelName, id, null, null, received));
            }
          }
        });

        downlodProcesses.remove('$modelName.$id');

        store.dispatch(DownloadFileStateAction(modelName, id, false, (response.statusCode==0), null));
      }catch(error){
        store.dispatch(DownloadFileStateAction(modelName, id, false, false, null));
        print(error);
      }
    }
    next(action);
  };
}

Middleware<AppState> _deleteFile(){
  return (Store store, action, NextDispatcher next) async{
    if(action is DeleteFileAction){
      String modelName = action.modelName;
      String id = action.id;
      String fileName = action.fileName;
      String directory = modelName;
      
      _DownLoadProcess downloadProcess = downlodProcesses['$modelName.$id'];
      if(downloadProcess!=null && downloadProcess.cancelToken!=null){
        downloadProcess.cancelToken.cancel("user cancelled");
        downlodProcesses.remove('$modelName.$id');
      }

      //store.dispatch(DownloadFileStateAction(modelName, id, true, false, null));

      try{
        final documentsDir = await getApplicationDocumentsDirectory();
        var dir = Directory('${documentsDir.path}/$directory');
        String path = '${dir.path}/$fileName';
        var file = File(path);
        if(await file.exists()){
          print('deleting from $path');
          await file.delete(recursive: false);
        }else{
          print('the file does not exists, ignoring!');
        }
        store.dispatch(DownloadFileStateAction(modelName, id, false, false, null));
      }catch(error){
        store.dispatch(DownloadFileStateAction(modelName, id, false, false, null));
        print(error);
      }
    }
    next(action);
  };
}

Middleware<AppState> _setupAlreadyDownloadedFiles(){
  return (Store store, action, NextDispatcher next) async{
    if(action is ListFetchingMoreRowsSucceedAction){
      String modelName = action.modelName;

      if(modelName=='glide' || modelName=='radio'){
        print('lets check files');

        for(var i=0; i < action.rows.length; i++){
          Map row = action.rows[i];
          String fileName = row['file']['filename'];
          int fileSize = row['file']['size'];
          String directory = modelName;
          final documentsDir = await getApplicationDocumentsDirectory();
          var dir = Directory('${documentsDir.path}/$directory');
          String path = '${dir.path}/$fileName';
          var file = File(path);
          if(await file.exists()){
            if((await file.length()) == fileSize){
              row['downloading'] = false;
              row['downloaded'] = true;
            }else{
              String id = row['id'];
              _DownLoadProcess dp = downlodProcesses['$modelName.$id'];
              if(dp!=null){
                row['downloading'] = true;
                row['downloaded'] = false;
              }else{
                row['downloading'] = false;
                row['downloaded'] = false;

                print('file abondoned, deleting from $path');
                await file.delete(recursive: false);
              }
            }
          }
        }
      }
    }
    next(action);
  };
}
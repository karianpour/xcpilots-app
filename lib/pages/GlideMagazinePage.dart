import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/data/translation.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:xcpilots/utils.dart';
import 'package:xcpilots/widgets/ui_utils.dart';

const int REFRESH_TIMEOUT = 1 * 24 * 60 * 60 * 1000;
const String directory = 'glide';

class GlideMagazinePage extends StatefulWidget {
  @override
  _GlideMagazinePageState createState() => _GlideMagazinePageState();
}

class _GlideMagazinePageState extends State<GlideMagazinePage> {
  static _GlideMagazinePageState _latestState;
  List<Map> _rows;
  int _lastFetch;
  bool _loading;
  bool _failed;

  _GlideMagazinePageState(){
    _loading = true;
    _failed = false;
    _latestState = this;
    bootState();
  }

  _stateFailed(){
    if(!this.mounted) return;
    setState((){
      _loading = false;
      _failed = true;
    });
  }
  _stateLoading(){
    if(!this.mounted) return;
    setState((){
      _loading = true;
      _failed = false;
    });
  }
  _stateRowsLoaded(List<Map> rows){
    if(!this.mounted) return;
    setState((){
      _rows = rows;
      _loading = false;
      _failed = false;
    });
  }

  _stateDownloadingRow(String id){
    _stateRowChanged(id, true, false);
  }

  _stateDownloadedRow(String id){
    _stateRowChanged(id, false, true);
  }

  _stateDeletedRow(String id){
    _stateRowChanged(id, false, false);
  }

  _stateRowChanged(String id, bool downloding, bool downloaded){
    if(_latestState ==null || !_latestState.mounted) return;
    var newRows = _latestState._rows.map((row){
      if(row['id']!=id){
        return row;
      }
      var newRow = Map.from(row);
      newRow['downloading'] = downloding;
      newRow['downloaded'] = downloaded;
      return newRow;
    }).toList();

    _latestState.setState(() {
      _latestState._rows = newRows;
    });
  }

  bootState() async{
    Map state = await restoreState(directory: directory);
    if(state!=null){
      List<Map> rows = await checkDownloadState(state['rows'].cast<Map>());
      if(!this.mounted) return;
      setState(() {
        _lastFetch = state['lastFetch'];
        _rows = rows;
      });
    }

    if(_rows==null || _lastFetch==null || DateTime.now().millisecondsSinceEpoch - _lastFetch > REFRESH_TIMEOUT){
      refreshGlide();
    }
  }

  Future<void> refreshGlide() async{
    _stateLoading();
    print('refreshing glide');
    if(!await isOnline()){
      print('no network, aborting!');
      return;
    }
    try{
      List<Map> rows = await XcPilotsApi.getInstance().fetchContentData(section: 'glide', before: null);
      _lastFetch = DateTime.now().millisecondsSinceEpoch;

      rows = await checkDownloadState(rows);

      _stateRowsLoaded(rows);
      persistState(state: {
        'lastFetch' : _lastFetch,
        'rows': _rows,
      }, directory: directory);
    }catch(error){
      print(error);
      _stateFailed();
    } finally {
      print('end fetching');
    }
  }

  Future<List<Map>> checkDownloadState(List<Map> rows) async{
    if(rows==null) return null;
    final documentsDir = await getApplicationDocumentsDirectory();
    print('checking for downloads ${documentsDir.path}');
    var dir = Directory('${documentsDir.path}/$directory');
    if(dir.existsSync()){
      rows = rows.map((data) {
        String fileName = data['file']['filename'];
        int fileSize = data['file']['size'];
        String path = '${dir.path}/$fileName';
        var file = File(path);
        if(file.existsSync()){
          if(file.lengthSync() == fileSize){
            data['downloading'] = false;
            data['downloaded'] = true;
          }else{
            data['downloading'] = true;
            data['downloaded'] = false;
          }
        }else{
          data['downloading'] = false;
          data['downloaded'] = false;
        }
        return data;
      }).toList();
    }
    return rows;
  }

  void handleDownload(Map data) async{
    String id = data['id'];
    String fileName = data['file']['filename'];
    int fileSize = data['file']['size'];
    String url = data['file']['src'];
    print("data $fileName $url");

    _stateDownloadingRow(id);

    var dio = new Dio();
    //dio.options.baseUrl = "http://api.iranxc.ir/";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout=5000;

    final documentsDir = await getApplicationDocumentsDirectory();
    var dir = Directory('${documentsDir.path}/$directory');
    await dir.create(recursive: true);

    String path = '${dir.path}/$fileName';
    print('downloading from $url to $path');

    Response response = await dio.download(
        'http://api.iranxc.ir$url', path, onProgress: (received, total) {
      print('$received,$fileSize');
    });

    if(response.statusCode==0)
      _stateDownloadedRow(id);
  }

  void handleOpen(Map data) async{
    String fileName = data['file']['filename'];

    if(data['downloaded']==null || !data['downloaded']) {
      print('the glide is not downloaded yet!');
      return;
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    var dir = Directory('${documentsDir.path}/$directory');
    String path = '${dir.path}/$fileName';
    print('opening from $path');
    var file = File(path);
    if(await file.exists()){
      OpenFile.open(path);
    }else{
      print('the file does not exists!');
    }
  }

  void handleDelete(Map data) async{
    String id = data['id'];
    String fileName = data['file']['filename'];

    if(data['downloaded']==null || !data['downloaded']) {
      print('the glide is not downloaded yet!');
      return;
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    var dir = Directory('${documentsDir.path}/$directory');
    String path = '${dir.path}/$fileName';
    print('deleting from $path');
    var file = File(path);
    if(await file.exists()){
      await file.delete(recursive: false);

      _stateDeletedRow(id);

    }else{
      print('the file does not exists!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('glide_magazin')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              String route = '/';
              // Navigator.pushNamed(context, route);
              Navigator.popUntil(context, ModalRoute.withName(route));
              // Navigator.pop(context);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        child: 
          _rows==null ? _loading ? 
            buildLoading() 
          : _failed ? 
            buildFailed(refreshGlide) 
          : 
            buildEmptyPlaceHolder(refreshGlide) 
          : _rows.length==0 ? 
            buildEmptyPlaceHolder(refreshGlide) 
          : 
            _glideList(context, _rows),
        onRefresh: refreshGlide,
      )
    );
  }

  Widget _glideList(BuildContext context, List<Map> rows) {
    return SafeArea(
        child: Container(
        constraints: BoxConstraints.expand(),
        child: ListView(
          padding: EdgeInsets.only(top: 20.0),
          children: rows.map((row) => _buildGlideCard(row)).toList(),
        ),
      ),
    );
  }

  Widget _buildGlideCard(Map data) {
    return FlatButton(
      padding: EdgeInsets.all(3.0),
      onPressed: () {
        this.handleOpen(data);
      },
      child: Card(
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: Row(
            children: buildGlideRow(context, data).toList(),
          ),
        )
      )
    );
  }

  Iterable<Widget> buildGlideRow(BuildContext context, Map data) sync* {
    yield Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "${data['title']}", 
            textAlign: TextAlign.start,
          ),
        ]
      )
    );

    if(data['downloading']!=null && data['downloading']) {
      yield CircularProgressIndicator();
    } else if(data['downloaded']!=null && data['downloaded']) {
      yield IconButton(
        icon: Icon(Icons.open_in_new),
        onPressed: (){
          this.handleOpen(data);
        }
      );
      yield IconButton(
        icon: Icon(Icons.delete),
        onPressed: (){
          this.handleDelete(data);
        }
      );
    } else {
      yield IconButton(
        icon: Icon(Icons.file_download),
        onPressed: (){
          print('download');
          this.handleDownload(data);
        }
      );
    }
  }
}



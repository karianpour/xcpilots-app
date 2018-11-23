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

class GlideMagazinePage extends StatefulWidget {
  @override
  _GlideMagazinePageState createState() => _GlideMagazinePageState();
}

class _GlideMagazinePageState extends State<GlideMagazinePage> {
  List _glides;
  int _lastFetch;
  bool _loading;
  bool _failed;

  _GlideMagazinePageState(){
    _loading = true;
    _failed = false;
    bootState();
  }

  bootState() async{
    Map state = await restoreState(directory: 'glide');
    if(state!=null){
      List rows = await checkDownloadState(state['glides']);
      setState(() {
        _lastFetch = state['lastFetch'];
        _glides = rows;
      });
    }

    if(_glides==null || _lastFetch==null || DateTime.now().millisecondsSinceEpoch - _lastFetch > REFRESH_TIMEOUT){
      refreshGlide();
    }
  }

  Future<void> refreshGlide() async{
    setState(() {
      _loading = true;
      _failed = false;
    });
    print('refreshing glider');
    if(!await isOnline()){
      print('no network, aborting!');
      return;
    }
    try{
      List rows = await XcPilotsApi.getInstance().fetchContentData(section: 'glide', before: null);
      _lastFetch = DateTime.now().millisecondsSinceEpoch;

      rows = await checkDownloadState(rows);

      setState((){
        _glides = rows;
        _loading = false;
      });
      persistState(state: {
        'lastFetch' : _lastFetch,
        'glides': _glides,
      }, directory: 'glide');
    }catch(error){
      print(error);
      setState((){
        _loading = false;
        _failed = true;
      });
    } finally {
      print('end fetching');
    }
  }

  Future<List> checkDownloadState(List rows) async{
    if(rows==null) return null;
    final directory = await getApplicationDocumentsDirectory();
    print('checking for downloads ${directory.path}');
    var dir = Directory('${directory.path}/glide');
    if(dir.existsSync()){
      rows = rows.map((data) {
        String fileName = data['file']['filename'];
        String path = '${dir.path}/$fileName';
        var file = File(path);
        if(file.existsSync()){
          data['downloading'] = false;
          data['downloaded'] = true;
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
    String url = data['file']['src'];
    print("data $fileName $url");

    var newGlides = _glides.map((glide){
      if(glide['id']!=id){
        return Map.from(glide);
      }
      var newGlide = Map.from(glide);
      newGlide['downloading'] = true;
      return newGlide;
    }).toList();

    setState(() {
      _glides = newGlides;
    });

    var dio = new Dio();
    //dio.options.baseUrl = "http://api.iranxc.ir/";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout=5000;

    final directory = await getApplicationDocumentsDirectory();


    var dir = Directory('${directory.path}/glide');

    await dir.create(recursive: true);

    String path = '${dir.path}/$fileName';
    print('downloading from $url to $path');

    Response response = await dio.download(
        'http://api.iranxc.ir$url', path, onProgress: (received, total) {
      print('$received,$total');
    });

    print(response.statusCode);

    newGlides = _glides.map((glide){
      if(glide['id']!=id){
        return Map.from(glide);
      }
      var newGlide = Map.from(glide);
      newGlide['downloading'] = false;
      newGlide['downloaded'] = true;
      return newGlide;
    }).toList();

    setState(() {
      _glides = newGlides;
    });

  }

  void handleOpen(Map data) async{
    String fileName = data['file']['filename'];

    if(data['downloaded']==null || !data['downloaded']) {
      print('the glide is not downloaded yet!');
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    var dir = Directory('${directory.path}/glide');
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

    final directory = await getApplicationDocumentsDirectory();
    var dir = Directory('${directory.path}/glide');
    String path = '${dir.path}/$fileName';
    print('deleting from $path');
    var file = File(path);
    if(await file.exists()){
      await file.delete(recursive: false);

      var newGlides = _glides.map((glide){
        if(glide['id']!=id){
          return Map.from(glide);
        }
        var newGlide = Map.from(glide);
        newGlide['downloading'] = false;
        newGlide['downloaded'] = false;
        return newGlide;
      }).toList();

      setState(() {
        _glides = newGlides;
      });

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
        child: _glides==null ? _loading ? buildLoading() : _failed ? buildFailed(refreshGlide) : buildEmptyPlaceHolder() : _gliderList(context, _glides),
        onRefresh: refreshGlide,
      )
    );
  }

  Widget _gliderList(BuildContext context, List glides) {
    return SafeArea(
        child: Container(
        constraints: BoxConstraints.expand(),
        child: ListView(
          padding: EdgeInsets.only(top: 20.0),
          children: glides.map((glide) => _buildGlideCard(glide)).toList(),
        ),
      ),
    );
  }

  Widget _buildGlideCard(Map data) {
    return FlatButton(
      padding: EdgeInsets.all(3.0),
      onPressed: () {
        print('whole pressed');
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



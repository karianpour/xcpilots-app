import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xcpilots/state/downloader.dart';
import 'package:xcpilots/state/list/list_model.dart';

class ContentCard extends StatelessWidget {
  final Map data;
  final int index;
  final ListModel listModel;

  ContentCard(this.data, this.index, this.listModel);

  void handleDownload(Map data) {
    print('handleDownload');
    String id = data['id'];
    String fileName = data['file']['filename'];
    int fileSize = data['file']['size'];
    String url = data['file']['src'];

    listModel.dispatch(DownloadFileAction(listModel.modelName, id, listModel.modelName, fileName, fileSize, url));
  }

  void handleCancel(Map data) {
    print('handleCancel');
    String id = data['id'];
    String fileName = data['file']['filename'];

    listModel.dispatch(DeleteFileAction(listModel.modelName, id, fileName));
  }

  void handleDelete(Map data) {
    print('handleDelete');
    String id = data['id'];
    String fileName = data['file']['filename'];

    listModel.dispatch(DeleteFileAction(listModel.modelName, id, fileName));
  }

  void handleOpen(Map data) async{
    print('handleOpen');
    String fileName = data['file']['filename'];

    if(data['downloaded']==null || !data['downloaded']) {
      print('the radio is not downloaded yet!');
      if(data['downloading']!=null && data['downloading']){
        handleCancel(data);
      }
      return;
    }

    final directory = listModel.modelName;

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

  @override
  Widget build(BuildContext context) {
    // print('build content card $index');
    return FlatButton(
      key: Key(data['id']),
      padding: EdgeInsets.all(3.0),
      onPressed: () {
        this.handleOpen(data);
      },
      child: Card(
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: Row(
            children: buildRadioRow(data).toList(),
          ),
        )
      )
    );
  }

  Iterable<Widget> buildRadioRow(Map data) sync* {
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

    String sizeStr;
    if(data.containsKey('file') && data['file'].containsKey('size')){
      sizeStr = '${Bidi.LRM}${(data['file']['size']/1024/1024).toStringAsFixed(2)} MB';
    }else{
      sizeStr = 'X';
    }

    if(data.containsKey('downloading') && data['downloading']) {
      int received = data['received'];
      if(received==null) received = 0;
      sizeStr = "${Bidi.LRM}${(received/1024/1024).toStringAsFixed(2)} / " + sizeStr;
    }
    yield Text(
      sizeStr, 
      textAlign: TextAlign.start,
    );

    if(data.containsKey('downloading') && data['downloading']) {
      yield CircularProgressIndicator();
    } else if(data.containsKey('downloaded') && data['downloaded']) {
      yield IconButton(
        icon: Icon(Icons.play_circle_outline),
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
          this.handleDownload(data);
        }
      );
    }
  }
}
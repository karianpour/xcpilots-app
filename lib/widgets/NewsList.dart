import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xcpilots/data/XcPilotsApi.dart';
import 'package:xcpilots/widgets/NewsCard.dart';

typedef Widget EmptyWidgetBuilder();
typedef Widget DivanListRowBuilder(Map row, int index);

class NewsList extends StatefulWidget {

  final XcPilotsApi serverInfo = XcPilotsApi.getInstance();

  @override
  _NewsListState createState() => new _NewsListState();
}


class _NewsListState extends State<NewsList> {
  var _rowQty = 0;
  var _noRowAvailable = false;
  var _lastTimeFailed = false;
  int _lastRowIndex;
  var _cachedRows = new Map<int, Map>();
  var _fetching = false;

  @override
  void initState(){
    _loadMoreRows();
    super.initState();
  }

  Future<Null> _handleRefresh() async{
    print('refteshing');
    setState(() {
      _rowQty = 0;
      _noRowAvailable = false;
      _lastTimeFailed = false;
      _lastRowIndex = null;
      _cachedRows = new Map<int, Map>();
      _fetching = false;
    });
    _loadMoreRows();
    return null;
  }

  Map _getRowData(int index){
    Map row = _cachedRows[index];
    if(row == null){
      row = {'loading': true};
      _cachedRows[index] = row;
      _loadMoreRows();
    }
    return row;
  }

  void _loadMoreRows(){
    if(_fetching) return;
    _fetching = true;
    print('start fetching');

    String before;

    if(_cachedRows != null && _lastRowIndex != null && _lastRowIndex >= 0){
      before = _cachedRows[_lastRowIndex]['created_at'];
      print('fetching before $before');
    }else{
      print('first time fetch');
    }
  

    widget.serverInfo.fetchNewsData(modelName: 'news', before: before)
    .then((List rows){
      setState((){
        //final List<dynamic> rows = json['data'];

        if(rows.length>0){
          var newDataStartIndex = _lastRowIndex==null ? 0 : _lastRowIndex + 1;
          _lastRowIndex = (_lastRowIndex == null ? -1 : _lastRowIndex) + rows.length;
          for(int i=0; i<rows.length; i++){
            final Map row = rows[i];
            _cachedRows[newDataStartIndex + i] = row;
          }
          _rowQty = _lastRowIndex + 1 + 1;
        }else{
          _noRowAvailable = true;
          _rowQty = _lastRowIndex + 1;
        }
      });
    }).catchError((error){
      setState(() {
        _lastTimeFailed = true;
      });
      print(error);
    }).whenComplete((){
      _fetching = false;
      print('end fetching');
    });
  }

  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),

      itemCount: _rowQty,

      itemBuilder: (context, index) {
        var row = _getRowData(index);
        return NewsCard(row, index);
      }
    );
  }

  Widget _buildLoading(){
    return const Center(
        child: const CupertinoActivityIndicator(),
    );
  }

  Widget _buildEmptyPlaceHolder(){
    return const Center(
        child: const Text('داده‌ای نیست!'),
    );
  }

  Widget _firstPageFailed(){
    return new RefreshIndicator(
      child: Center(
        // child: new Container(

          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('مشکلی در ارتباط با سرور بوجود آمد. مجدد تلاش کنید!'),
              new FlatButton(
                child: const Text('تلاش مجدد'),
                onPressed: _handleRefresh,
              )
            ],
          )
        ),
      // ),
      onRefresh: _handleRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_rowQty==0){
      if(_lastTimeFailed)
        return _firstPageFailed();
      else if(_noRowAvailable)
        return _buildEmptyPlaceHolder();
      else
        return _buildLoading();
    }
    return new RefreshIndicator(
      child: SafeArea(
        child: _buildList()
      ),
      onRefresh: _handleRefresh,
    );
  }
}
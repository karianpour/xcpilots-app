import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xcpilots/data/translation.dart';

Widget buildEmptyPlaceHolder(Function refresh){
  return RefreshIndicator(
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        Container(height: 80.0,),
        Center(
          child: const Text('no data'),
        )
      ],
    ),
    onRefresh: refresh,
  );
}

Widget buildLoading(){
  return const Center(
      child: const CupertinoActivityIndicator(),
  );
}

Widget buildFailed(Function refresh){
  return RefreshIndicator(
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        Container(height: 80.0,),
        Center(child: const Text('problem while connecting to the server')),
      ],
    ),
    onRefresh: refresh,
  );
}

Widget buildFaildCard(Function loadMore){
  return FlatButton(
    child: Container(
      height: 80.0,
      child: Center(
        child: Text(translate('faild to load, press to retry'))
      ),
    ),
    onPressed: (){
      print('let\'s try again');
      loadMore();
    },
  );
}

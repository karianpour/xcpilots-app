import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget buildEmptyPlaceHolder(Function refresh){
  return RefreshIndicator(
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        Container(height: 80.0,),
        Center(
          child: const Text('داده‌ای نیست!'),
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
        Center(child: const Text('مشکلی در ارتباط با سرور بوجود آمد. مجدد تلاش کنید!')),
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
        child: const Text('faild to load, press to retry')
      ),
    ),
    onPressed: (){
      print('let\'s try again');
      loadMore();
    },
  );
}

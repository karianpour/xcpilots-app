import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

Widget buildEmptyPlaceHolder(){
  return const Center(
      child: const Text('داده‌ای نیست!'),
  );
}

Widget buildLoading(){
  return const Center(
      child: const CupertinoActivityIndicator(),
  );
}

Widget buildFailed(Function refresh){
  return RefreshIndicator(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('مشکلی در ارتباط با سرور بوجود آمد. مجدد تلاش کنید!'),
          FlatButton(
            child: const Text('تلاش مجدد'),
            onPressed: refresh,
          )
        ],
      )
    ),
    onRefresh: refresh,
  );
}

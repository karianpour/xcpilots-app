import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image/network.dart';
import 'package:xcpilots/models/news_model.dart';  

class NewsList extends StatelessWidget {

  //final ScrollController _scrollController = ScrollController();

  // NewsList(){
  //   _scrollController.addListener((){
  //     print('position: ${_scrollController.position}');
  //   });
  // }

  Map _getRowData(NewsListModel vm, int index){
    Map row = vm.rows[index.toString()];
    if(row == null){
      vm.rows[index.toString()] = {'loading': true};
      vm.fetchMoreRows();
    }
    return row;
  }


  Widget _buildList(NewsListModel vm){
    return NotificationListener(
      onNotification: (notifiction){
        if(notifiction is ScrollNotification){
          vm.saveScrollPosition(notifiction.metrics.pixels);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        controller: vm.scrollController,

        itemCount: vm.rowQty,

        itemBuilder: (context, index) {
          var row = _getRowData(vm, index);
          return NewsCard(row, index);
        }
      ),
    );
  }

  Widget _buildLoading(NewsListModel vm){
    if(vm!=null) vm.fetchMoreRows();
    return const Center(
        child: const CupertinoActivityIndicator(),
    );
  }

  Widget _buildEmptyPlaceHolder(){
    return const Center(
        child: const Text('داده‌ای نیست!'),
    );
  }

  Widget _firstPageFailed(NewsListModel vm){
    return RefreshIndicator(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('مشکلی در ارتباط با سرور بوجود آمد. مجدد تلاش کنید!'),
            FlatButton(
              child: const Text('تلاش مجدد'),
              onPressed: vm.refresh,
            )
          ],
        )
      ),
      onRefresh: vm.refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewsListModel>(
    		// Build a viewModel, as usual:
        converter: NewsListModel.fromStore,
        builder: (BuildContext context, NewsListModel vm) {

          if(vm==null){
            return _buildLoading(vm);
          }

          if(vm.rowQty==0){
            if(vm.lastTimeFailed)
              return _firstPageFailed(vm);
            else if(vm.noRowAvailable)
              return _buildEmptyPlaceHolder();
            else
              return _buildLoading(vm);
          }
          return new RefreshIndicator(
            child: SafeArea(
                child: _buildList(vm),
            ),
            onRefresh: vm.refresh,
          );


        });
  }
}

class NewsCard extends StatelessWidget {

  final Map data;
  final int index;

  NewsCard(this.data, this.index);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(3.0),
      onPressed: () {
       String route = '/single_news/${data["id"]}';
       Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 4.0/3.0,
                      child: buildNewsImage(data)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getNewsTitle(data),
                        textAlign: TextAlign.start,
                        style: DefaultTextStyle.of(context).style.apply(
                          fontSizeFactor: 1.5).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getNewsDescription(data), 
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

final double imageSize = 160.0;

Widget buildNewsImage(data){
  var url = findNewsImageUrl(data);
  if(url!=null){
    // return CachedNetworkImage(
    //   placeholder: CircularProgressIndicator(),
    //   imageUrl: url,
    //   errorWidget: new Icon(Icons.error),
    // );
    // return FadeInImage.memoryNetwork(
    //             placeholder: kTransparentImage,
    //             image: url,
    //                // 'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
    //           );
    // return Image.network(url, fit: BoxFit.fitWidth,);
    // print(url);
    return FadeInImage(
            placeholder: AssetImage('assets/images/loading.gif'),
            image: NetworkImageWithRetry(url),
            fit: BoxFit.fitWidth,
          );
  }else{
    return Icon(Icons.photo_camera, size: imageSize);
  }
}
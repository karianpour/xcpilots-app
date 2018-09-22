import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xcpilots/actions/news_actions.dart';
import 'package:xcpilots/models/app_state.dart';
import 'package:xcpilots/widgets/NewsCard.dart';

class NewsList extends StatelessWidget {

  Map _getRowData(_ViewModel vm, int index){
    Map row = vm.rows[index];
    if(row == null){
      vm.rows[index] = {'loading': true};
      vm.fetchMoreRows();
    }
    return row;
  }


  Widget _buildList(_ViewModel vm){
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),

      itemCount: vm.rowQty,

      itemBuilder: (context, index) {
        var row = _getRowData(vm, index);
        return NewsCard(row, index);
      }
    );
  }

  Widget _buildLoading(_ViewModel vm){
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

  Widget _firstPageFailed(_ViewModel vm){
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
    return new StoreConnector<AppState, _ViewModel>(
    		// Build a viewModel, as usual:
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {

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
              child: _buildList(vm)
            ),
            onRefresh: vm.refresh,
          );


        });
  }
}

class _ViewModel {
  final int rowQty;
  final bool noRowAvailable;
  final bool lastTimeFailed;
  final int lastRowIndex;
  final Map rows;
  final bool fetching;

  final VoidCallback refresh;
  final VoidCallback fetchMoreRows;

  _ViewModel({this.rowQty, this.noRowAvailable, this.lastTimeFailed, this.lastRowIndex, this.rows, this.fetching, this.refresh, this.fetchMoreRows});

  static _ViewModel fromStore(Store<AppState> store){
    Map news = store.state.state['news'];

    if(news==null){
      store.dispatch(new NewsRefreshAction());
      news = store.state.state['news'];
    }

    // //todo remove it

    // news = news ?? {
    //   'rowQty': 0,
    //   'noRowAvailable': false,
    //   'lastTimeFailed': false,
    //   'lastRowIndex': null,
    //   'rows': [],
    //   'fetching': false,
    // };
    return _ViewModel(
      rowQty: news['rowQty'],
      noRowAvailable: news['noRowAvailable'],
      lastTimeFailed: news['lastTimeFailed'],
      lastRowIndex: news['lastRowIndex'],
      rows: news['rows'],
      fetching: news['fetching'],
      refresh: () {
        store.dispatch(new NewsRefreshAction());
      },
      fetchMoreRows: () {
        store.dispatch(new NewsFetchMoreRowsAction());
      },
    );
  }
}
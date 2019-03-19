import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xcpilots/state/list/list_manager.dart';
import 'package:xcpilots/state/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:xcpilots/state/list/list_model.dart';
import 'package:xcpilots/utils.dart';
import 'package:xcpilots/widgets/ui_utils.dart';

Timer _debounce;

typedef C = Widget Function(Map, int, ListModel);

class InfinitList extends StatelessWidget {
  final String modelName;
  final C cardWidget;

  // final ScrollController _scrollController = ScrollController();

  InfinitList(this.modelName, this.cardWidget){
    // _scrollController.addListener((){
    //   print('position: ${_scrollController.position}');
    // });
  }

  Map _getRowData(ListModel vm, int index){
    Map row = vm.rows[index.toString()];
    if(row == null){
      row = {'loading': true};
      vm.rows[index.toString()] = row;
      vm.fetchMoreRows(false);
    }
    return row;
  }

  _handleScrollPositionChanged(ListModel vm, double position) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      vm.saveScrollPosition(position);
    });
  }

  Widget _buildList(ListModel listModel){
    return NotificationListener(
      onNotification: (notifiction){
        if(notifiction is ScrollNotification){
          _handleScrollPositionChanged(listModel, notifiction.metrics.pixels);
        }
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0.0),
        controller: listModel.scrollController,

        itemCount: listModel.rowQty,

        itemBuilder: (context, index) {
          var row = _getRowData(listModel, index);
          if(row.containsKey('loading') && row['loading']){
            if(listModel.lastTimeFailed){
              return buildFaildCard(tryToLoadMore(listModel));
            }else{
              return buildLoading();
            }
          }
          return cardWidget(row, index, listModel);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  // print('build infinitlist');
    return StoreConnector<AppState, ListModel>(
    		// Build a viewModel, as usual:
        converter: ListModel.listFromStore(modelName),
        builder: (BuildContext context, ListModel vm) {
          manageList(vm);
          if(vm.rowQty == 0 && vm.lastTimeFailed)
            return buildFailed(vm.refresh);
          else if(vm.rowQty == 0 && vm.fetching)
            return buildLoading();
          else if(vm.rowQty == 0 || vm.noRowAvailable)
            return buildEmptyPlaceHolder(vm.refresh);
          else
            return RefreshIndicator(
              child: SafeArea(
                  child: _buildList(vm),
              ),
              onRefresh: tryToRefresh(vm),
            );
        });
  }
}

Function tryToRefresh(ListModel vm) {
  return () async {
    if(await isOnline()){
      vm.refresh();
    }
  };
}

Function tryToLoadMore(ListModel vm) {
  return () async {
    if(await isOnline()){
      vm.fetchMoreRows(false);
    }
  };
}

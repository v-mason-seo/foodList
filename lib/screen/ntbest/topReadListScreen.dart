import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/model/item.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/topReadCell.dart';
import 'package:foodmenu_hdhardwork/service/nunting_api.dart';

import '../../service/ads.dart';

class TopReadListScreen extends StatefulWidget {
  @override
  TopReadListScreenState createState() => TopReadListScreenState();

  const TopReadListScreen();
}

class TopReadListScreenState extends State<TopReadListScreen> {
  Future<List<Item>> itemList;

  @override
  void initState() {
    super.initState();

    itemList = NuntingApi().getTopOfTopItems();
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    // Ads().hideBanner();
    super.dispose();
  }

  Future<List<Item>> _refresh() {
    setState(() {
      itemList = NuntingApi().getTopOfTopItems();
    });
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('눈팅베스트', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: FutureBuilder<List<Item>>(
          future: itemList,
          builder: (BuildContext contenxt, AsyncSnapshot snapshots) {
            switch (snapshots.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshots.hasError) {
                  return Center(
                    child: Text('데이터 오류'),
                  );
                }
            }
            List<Item> itemList = snapshots.data;
            itemList.shuffle();
            return RefreshIndicator(
                onRefresh: _refresh,
                child: SafeArea(
                    child: Column(
                  children: <Widget>[
                    Expanded(
                      
                      child: ListView.separated(
                        itemCount: itemList.length,
                        separatorBuilder: (context, i) =>
                            Divider(color: Colors.grey),
                        itemBuilder: (conext, index) {
                          final Item item = itemList[index];
                          return topReadCell(context, item, index + 1);
                        },
                      ),
                    ),
                  ],
                )));
          },
        ));
  }
}

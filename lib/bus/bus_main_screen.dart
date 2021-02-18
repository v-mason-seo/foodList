import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/bus/busModel.dart';
import 'package:foodmenu_hdhardwork/bus/bus_list_view.dart';
import 'package:foodmenu_hdhardwork/bus/bus_service.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';
import 'package:provider/provider.dart';

class BusMainScreen extends StatelessWidget {
  const BusMainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "버스",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                    child: Text("즐겨찾기",
                        style: TextStyle(color: Colors.white, fontSize: 20))),
                Tab(
                    child: Text(
                  ("출근"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                Tab(
                    child: Text(
                  ("퇴근"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))
              ],
            ),
          ),
          // body: BaseWidget<BusModel>(
          //   model: BusModel(
          //     busService: Provider.of<BusService>(context),
          //   ),
          //   onModelReady: (model) => model.loadData(),
          //   builder: (context, model, _) {

          //     if ( model.busy) {
          //       return Center(child: CircularProgressIndicator(),);
          //     }

          //     return TabBarView(
          //       children: <Widget>[
          //         BusListView(queryType: BusListType.bookmark,),
          //         BusListView(queryType: BusListType.gowork,),
          //         BusListView(queryType: BusListType.gohome,),
          //       ]
          //     );
          //   },
          // ),
          body: 
            ChangeNotifierProvider.value(
              value: Provider.of<BusService>(context),
              child: TabBarView(
              children: <Widget>[
                BusListView(
                  queryType: BusListType.bookmark,
                ),
                BusListView(queryType: BusListType.gowork),
                BusListView(queryType: BusListType.gohome),
              ],
            )
        )
      )
    );
  }
}

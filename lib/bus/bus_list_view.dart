import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmenu_hdhardwork/bus/busModel.dart';
import 'package:foodmenu_hdhardwork/bus/bus_schedule_screen.dart';
import 'package:foodmenu_hdhardwork/bus/bus_service.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';

import 'package:provider/provider.dart';

import '../service/ads.dart';
import 'model/busSchedule.dart';

enum BusListType { bookmark, gowork, gohome }

class BusListView extends StatelessWidget {
  final BusListType queryType;
  const BusListView({Key key, this.queryType}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final BusService busService = Provider.of<BusService>(context);
    final busScheduleList = busService.getBusScheduleList(queryType);
    return Container(
        // margin: EdgeInsets.only(
        //     bottom: Ads().getMargin(MediaQuery.of(context).size.height)),
        child: ListView.builder(
          itemCount: busScheduleList.length,
          itemBuilder: (BuildContext context, int index) {
            BusSchedule busSchedule = busScheduleList[index];

            return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // fullscreenDialog: true,
                          builder: (context) => ChangeNotifierProvider.value(
                              value: busService,
                              child: BusScheduleScreen(
                                  busSchedule: busSchedule))));
                },
                trailing: busSchedule.bookmark == true
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // width: 35,
                      // color: busSchedule.gowork == true
                      //     ? Colors.red
                      //     : Colors.blueAccent,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: busSchedule.gowork ? Colors.red : Colors.blueAccent,
                      ),
                      child: Text(
                        (busSchedule.gowork == true ? "출근" : "퇴근"),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),
                      busSchedule.holiday == true ?
                 Container(
            //width: 35,
            //color: busSchedule.holiday == true ? Colors.orange : Colors.blueAccent,
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: busSchedule.holiday ? Colors.orange : Colors.blueAccent,
                      ),
            child: Text(
              ( "휴일"),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.0),
            ),
          ) :
          Container(),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      busSchedule.start,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(Icons.keyboard_arrow_right),
                    ),
                    Text(
                      busSchedule.end,
                    ),
                  ],
                ));
          },
        ));
  }
}

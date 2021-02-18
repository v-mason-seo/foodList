import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/bus/bus_list_view.dart';
import 'package:foodmenu_hdhardwork/bus/bus_service.dart';
import 'package:foodmenu_hdhardwork/bus/model/busSchedule.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_model.dart';


class BusModel extends BaseModel {

  BusListType queryType;
  BusService busService;

  List<BusSchedule> list;

  BusModel({
    this.queryType,
    this.busService,
  });

  Future loadData() async {
    setBusy(true);
    list = await busService.getBusScheduleList(queryType);
    setBusy(false);
  }
}
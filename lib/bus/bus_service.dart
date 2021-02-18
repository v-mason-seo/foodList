import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'bus_list_view.dart';
import 'model/busSchedule.dart';

class BusService with ChangeNotifier {
  static const String BUS_SCHEDULE = 'bus_schedule1';
  static const String FAVORITE_BUS_SCHEDULE = 'favorite_bus_schedule';

  List<BusSchedule> _busScheduleList = [];
  List<BusSchedule> get bookmarkBusSchedule =>
      _busScheduleList.where((bus) => bus.bookmark == true).toList();
  List<BusSchedule> get goWorkBusSchedule =>
      _busScheduleList.where((bus) => bus.gowork == true).toList();
  List<BusSchedule> get goHomeBusSchedule =>
      _busScheduleList.where((bus) => bus.gowork != true).toList();

  BusService() {
    _load();
  }

  _load() async {
    String localData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localData = prefs.getString(BUS_SCHEDULE);

    // if (data == null) {
    //   data = await rootBundle.loadString("lib/bus/bus_data.json");
    // }

    List<BusSchedule> localBusData = await loadLocalBusData();;
    _busScheduleList = await loadBusData();

    for( var item in _busScheduleList) {
      
      BusSchedule bookmarkData = localBusData.singleWhere( (v) {
        return v.start == item.start 
              && v.end == item.end
              && v.gowork == item.gowork
              && v.holiday == item.holiday
              && v.bookmark == true;
      }, orElse: () => null);

      if ( bookmarkData != null) {
        item.bookmark = true;
      }
    }

    notifyListeners();
  }

  Future<List<BusSchedule>> loadLocalBusData() async {

    List<BusSchedule> busScheduleList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String localData = prefs.getString(BUS_SCHEDULE);

    try {
      final parsed = json.decode(localData).cast<Map<String, dynamic>>();
      busScheduleList = parsed
          .map<BusSchedule>((json) => BusSchedule.fromJson(json))
          .toList();
    } catch (err) {
      //_busScheduleList = [];
    }

    return busScheduleList;
  }

  Future<List<BusSchedule>> loadBusData() async {
    
    List<BusSchedule> busScheduleList = [];
    String url = "https://s3.ap-northeast-2.amazonaws.com/ddafoodlist/hdhardwork/bus_data";
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    
    try {
      
      String decodeResponse = utf8.decode(response.bodyBytes);
      //print(decodeResponse);
      final parsed = json.decode(decodeResponse).cast<Map<String, dynamic>>();
      busScheduleList = parsed
          .map<BusSchedule>((json) => BusSchedule.fromJson(json))
          .toList();
    } catch(e) {
      busScheduleList  = await loadLocalBusData();
    }

    return busScheduleList;
  }

  List<BusSchedule> getBusScheduleList(BusListType queryType) {
    if (queryType == BusListType.bookmark) return bookmarkBusSchedule;
    if (queryType == BusListType.gowork) return goWorkBusSchedule;
    if (queryType == BusListType.gohome) return goHomeBusSchedule;
  
    return goWorkBusSchedule;
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var busScheduleListJson = json.encode( _busScheduleList);
    prefs.setString(BUS_SCHEDULE, busScheduleListJson);
  }

  setBookmark(BusSchedule busSchedule) {
    busSchedule.bookmark = !busSchedule.bookmark ?? false;
    notifyListeners();
    save();
  }
}

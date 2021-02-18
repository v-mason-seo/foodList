import 'dart:io';

import 'package:foodmenu_hdhardwork/screen/ntbest/model/item.dart';

import "package:http/http.dart" as http;
import 'dart:convert';

class NuntingApi {
  NuntingApi._privateConstructor();
  static final NuntingApi _instance = NuntingApi._privateConstructor();
  static final String baseUrl = "http://api.nunting.kr:4000";
  factory NuntingApi() {
    return _instance;
  }


  Future<List<Item>> getTopOfTopItems() async {
    final response = await http.get(baseUrl +  '/tot');

    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      List<Item> _topReadItems =
          responseJson.map((i) => Item.fromJson(i)).toList();

      return _topReadItems;
    } else {
      // return new List<Item>();
      throw Exception('Failed to load');
    }
  }

  //   Future<List<Item>> getDayTopItems(int day) async {
  //   final response = await http.get(baseUrl +  '/livenb/day/$day');

  //   if (response.statusCode == 200) {
  //     List<dynamic> responseJson = json.decode(response.body);
  //     List<Item> _topReadItems =
  //         responseJson.map((i) => Item.fromJson(i)).toList();

  //     _topReadItems.removeWhere((p) => SettingManager().isUnWatchingSid(p.sid));
  //     return _topReadItems;
  //   } else {
  //     // return new List<Item>();
  //     throw Exception('Failed to load');
  //   }
  // }



  
  Future<bool> deletedContent(String url) async {
    var body = json.encode({
        'url': url,
      });
    String serverUrl = '$baseUrl/tot/deleted';
    final response = await http.put(
      serverUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body
    );

    if (response.statusCode == 200){
      return true;
    }
    return false;

    // print('------------------------------');
    // print('[----->deletedContent<-----] status code : ${response.statusCode}');
    // print('------------------------------');
  }
}

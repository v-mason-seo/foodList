import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';

class UserService with ChangeNotifier {
  UserService._privateConstructor();
  static final UserService _instance = UserService._privateConstructor();
  factory UserService() {
    return _instance;
  }
  static const String USER_NICKNAME = 'nickname';
  static const String SELECTED_RESTAURANT = 'sel_restaurant';
  static const String RESTAURANT_LIST = 'list_restaurant';

  static const int RESTAURANT_MORNING_FROM = 3;
  // static const int Restaurant_morning_to = 10;
  static const int RESTAURANT_LAUNCH_FROM = 10;
  // static const int Restaurant_launch_to = 1W5;
  static const int RESTAURANT_DINNER_FROM = 16;
  // static const int Restaurant_dinner_to = 20;
  static const int RESTAURANT_NIGHT_FROM = 21;
  // static const int Restaurant_night_to = 10;
  List<int> restaurantTime = [3, 10, 16, 21];

  String accessKey;

  // Restaurant restaurant;
  // List<Restaurant> restaurantList = [];

  // StreamController<Restaurant> selectedRestaurantStreamController = StreamController();

  Future<String> getNickName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nickname = prefs.getString(USER_NICKNAME);

    if (nickname == null) {
      String randomNickName = '익명${randomNumeric(4)}';
      prefs.setString(USER_NICKNAME, randomNickName);
      return randomNickName;
    }
    return nickname;
  }

  void init() async {
    // restaurant = loadSharedRestaurant();
    // restaurantList = await loadSharedRestaurantList();
  }

  //login
  void setAccessKey(String accessKey) {}
  //restaurant
  void setSelectRestaurant(Restaurant restaurant) {
    // selectedRestaurantStreamController.add(restaurant);
    notifyListeners();
  }

  void updateNickName(String nickName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_NICKNAME, nickName);
  }

  int getCurrentTimeIndex() {
    var date = DateTime.now().toLocal();

    for (var i = 0; i < restaurantTime.length; i++) {
      if (date.hour < restaurantTime[i]) {
        return i - 1;
      }
    }

    return 0;
  }
}

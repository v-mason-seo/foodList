import 'dart:convert';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_model.dart';
import 'package:foodmenu_hdhardwork/utils/restaurant_template.dart';
import 'package:foodmenu_hdhardwork/vo/app_config.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';


class RestaurantService extends BaseModel {
  static const String SELECTED_RESTAURANT = 'sel_restaurant';
  static const String SELECTED_RESTAURANT_IDX = 'select_restaurant_idx';
  static const String RESTAURANT_LIST = 'list_restaurant';

  RestaurantService() {
    load();
  }

  Restaurant _restaurant;
  List<Restaurant> _restaurantList = [];
  AppConfig appConfig;
  

  Restaurant get getSelectedRestaurant => _restaurant;

  Restaurant get chatRestaurant => RestaurantTemplate().restaurantList[0];
  
  String get getRestaurantName {
    if (_restaurant == null) return "구내식당";
    return _restaurant.name;
  }

  Restaurant getRestaurantFromList(index) {
    return _restaurantList[index];
  }

  List<Restaurant> get getRestaurantList => _restaurantList;
  

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_restaurant != null) {
      String restaurantJson = json.encode(_restaurant);
      prefs.setString(SELECTED_RESTAURANT, restaurantJson);
    }

    if (_restaurantList != null && _restaurantList.length > 0) {
      var restaurantListJson = json.encode(_restaurantList);
      //print(restaurantListJson);
      prefs.setString(RESTAURANT_LIST, restaurantListJson);
    }
  }

  load() async {
    setBusy(true);
    await loadSharedRestaurant();
    await loadSharedRestaurantList();
    try {
      appConfig = await Api().loadConfig();
    } catch(e) {
      appConfig = AppConfig();
    }

    setBusy(false);
  }

  ///
  /// 개인 광고가 나온 시간 저장
  ///
  void saveShowPrivateAdDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String yyyyMMdd = DateFormat("yyyyMMdd").format(now);
    prefs.setString("show_private_ad_date", yyyyMMdd);
  }

  ///
  /// 개인 전면 광고가 나온 시간
  /// 하루에 한번만 노출되도록 하기 위함.
  ///
  Future<String> getShowPrivateAdDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("show_private_ad_date");
  }


  ///
  /// 개인 전면 광고 노출 여부
  ///
  Future<bool> isShowPrivateFullAd() async {

    // 개인 광고 노출 여부
    if ( isEnablePrivateAd() ) {

      String showAdDate = await getShowPrivateAdDate();
      DateTime now = DateTime.now();
      String yyyyMMdd = DateFormat("yyyyMMdd").format(now);

      // 전면 광고는 하루에 한번만 나오도록
      if ( showAdDate != yyyyMMdd ) {
        return true;
      }
    }

    return false;
  }

  ///
  /// 개인 광고를 노출할지 안할지 여부
  ///
  bool isEnablePrivateAd() {

    if ( appConfig != null) {
      return appConfig.showPrivateAd;
    }

    return false;
  }

  Future loadSharedRestaurant() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sharedData = prefs.getString(SELECTED_RESTAURANT);

    if (sharedData == null)  {
      _restaurant = RestaurantTemplate().selectedRestaurant;
      save();
      return;
    }

    var decodeRestaurant = json.decode(sharedData);
    Restaurant restaurant = Restaurant.fromJson(decodeRestaurant);

    setSeletecRestaurant(restaurant);
  }

  Future loadSharedRestaurantList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedRestaurantList = prefs.getString(RESTAURANT_LIST);
    List<Restaurant> restaurantList = [];

    //todo. 테스트를 위해서 템플릿에서 무조건 데이터 가져오도록 함.
    _restaurantList = RestaurantTemplate().restaurantList;
    save();
    return;

    if( savedRestaurantList == null) {
       _restaurantList = RestaurantTemplate().restaurantList;
      save();
      return;
    }

    try {
        final parsed = json.decode(savedRestaurantList).cast<Map<String, dynamic>>();
        restaurantList = parsed
            .map<Restaurant>((json) => Restaurant.fromJson(json))
            .toList();

        if (restaurantList == null) {
          _restaurantList = RestaurantTemplate().restaurantList;
        }else{
          _restaurantList = restaurantList;
        }
      } catch (err) {
        return _restaurantList = RestaurantTemplate().restaurantList;
      }
  }



  setSelectRestaurantAndSave(int index) async {
    _restaurant = _restaurantList[index];
    //notifyListeners();
    await save();
    notifyListeners();
  }

  void setSeletecRestaurant(Restaurant newRestaurant) {
    _restaurant = newRestaurant;
    notifyListeners();
  }


  setRestaurantAndReorder(int index) async {
    setSeletecRestaurant(_restaurantList[index]);
    _restaurantList.removeAt(index);
    _restaurantList.insert(0, _restaurant);
    save();
  }


  addRestaurant(Restaurant restaurant) async {
    setSeletecRestaurant(restaurant);
    if (_restaurantList.contains(restaurant) == false) {
      _restaurantList.insert(0, restaurant);
    }
    save();
  }

  void removeRestaurant(index) async {
    if (_restaurantList == null) return;
    if (_restaurantList[index] == null) return;
    if(_restaurantList[index].id == _restaurant.id) return ;

    _restaurantList.removeAt(index);

  }

  bool isNeedPasswordRestaurant() {
    if (_restaurant == null) return false;
    if (_restaurant.password == null) return false;
    if (_restaurant.password.isEmpty) return false;
    return true;
  }
}

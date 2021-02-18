import 'package:foodmenu_hdhardwork/vo/restaurant.dart';

class RestaurantTemplate {

  final title = "현대중공업 식단표";
  final Restaurant selectedRestaurant =
      new Restaurant(id: 54, extid: "hdhardwork", name: "현대중공업(현장)");
  final List<Restaurant> restaurantList = [
    Restaurant(id: 54, extid: "hdhardwork", name: "현대중공업(현장)"),
    Restaurant(id: 55, extid: "hdhardwork_rest" ,name: "현대중공업(숙소)"),
    Restaurant(id: 0, extid: "hdhardwork_rest" ,name: "현장+숙소"),
  ];

  final extGrp = "5";
  final fullAdRandom = 5;

//네이티브앱에서 하기떄문에 따로 하지 않았음
  final admobAppIdAndroid = 'ca-app-pub-6608605689570528~9896467940';
  final admobUnitIdAndroid = 'ca-app-pub-6608605689570528/8747037807';
  final admobFullScreenIdAndroid = 'ca-app-pub-6608605689570528/5656657146';

  final admobAppIdios = 'ca-app-pub-6608605689570528~4569036600';
  final admobUnitIdIos = 'ca-app-pub-6608605689570528/1725274704';
  final admobFullScreenIDIos = 'ca-app-pub-6608605689570528/8760945946';
}

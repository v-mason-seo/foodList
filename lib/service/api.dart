import 'dart:async';
import 'dart:convert';
import 'package:foodmenu_hdhardwork/vo/app_config.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../vo/restaurant.dart';
import '../vo/boardVo.dart';

class Api {
  Api._privateConstructor();
  static final Api _instance = Api._privateConstructor();
  factory Api() {
    return _instance;
  }

  final String baseUrl = 'http://api.gune.kr:15300/v2';

  Future<FoodMenu> loadFood(Restaurant restaurant, String yymmdd) async {
    String url = restaurant.getLoadUri(yymmdd);
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    FoodMenu foodmenu;

    try {
      String decodeResponse = utf8.decode(response.bodyBytes);
      foodmenu = FoodMenu.fromJson(json.decode(decodeResponse));
    } catch (err) {
      foodmenu = FoodMenu(id: yymmdd, mealList: [
        MealVo(category: "조식", data: []),
        MealVo(category: "중식", data: []),
        MealVo(category: "석식", data: []),
        MealVo(category: "야식", data: [])
      ]);
    }

    return foodmenu;
  }

  Future<List<Restaurant>> loadRestaurantList(
      String category, String search) async {
    final response = await http
        .get(baseUrl + '/restaurants?category=$category');
    final jsonData = json.decode(response.body);
    List<Restaurant> restaurantList =
        List<Restaurant>.from(jsonData.map((x) => Restaurant.fromJson(x)));
    return restaurantList;
  }

  ///
  /// 게시판 글쓰기
  ///
  Future<Response> createBoard(int gid, String writer, String body) async {
    var response = await http.post(baseUrl + '/boards', body: {
      'gid': gid.toString(),
      'writer': writer,
      'body': body,
    });

    return response;
  }

  ///
  /// 게시글 가져오기
  ///
  Future<List<BoardVo>> loadBoardList(int gid, {int offset: 0}) async {
    final response = await http.get(
      baseUrl + '/boards/$gid?limit=20&offset=$offset',
      // headers: {'Content-Type': 'application/json;charset=utf-8'},
    );
    final parsed = json.decode(response.body);
    return parsed.map<BoardVo>((json) => BoardVo.fromJson(json)).toList();
    // Use the compute function to run parsePhotos in a separate isolate
  }

  void reportBoardContent(BoardVo board) async {
    var bid = board.bid;
    await http.patch(
      baseUrl + '/boards/$bid/report',
      // headers: {'Content-Type': 'application/json;charset=utf-8'},
    );
  }

  ///로그인
  Future<Response> login(String email, String pw) async {
    var response = await http.post(baseUrl + '/auth/login',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'pw': pw});

    return response;
  }



  Future<AppConfig> loadConfig() async {
    
    String url = "https://s3.ap-northeast-2.amazonaws.com/ddafoodlist/hdhardwork/config/hdhardwork_config";
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    AppConfig appConfig;
    
    try {
      
      String decodeResponse = utf8.decode(response.bodyBytes);
      final parsed = json.decode(decodeResponse);
      appConfig = AppConfig.fromJson(parsed);
    } catch(e) {
      appConfig = AppConfig();
    }

    return appConfig;
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/RestaurantSelectView.dart';
import 'package:foodmenu_hdhardwork/bus/bus_main_screen.dart';
import 'package:foodmenu_hdhardwork/bus/bus_service.dart';
import 'package:foodmenu_hdhardwork/screen/chat/food_chat_screen.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/food_multiple_menu_page.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_model.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_page.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/topReadListScreen.dart';
import 'package:foodmenu_hdhardwork/service/ads.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:foodmenu_hdhardwork/utils/restaurant_template.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'ad/ad_dialog.dart';

class FoodNoteHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FoodNoteHomePageState();
}

class _FoodNoteHomePageState extends State<FoodNoteHomePage> with 
    SingleTickerProviderStateMixin {

  final int TAB_LENGTH = 7;
  List<DateTime> _pagedate;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pagedate = [
      DateTime.now().add(Duration(days: -1)),
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 3)),
      DateTime.now().add(Duration(days: 4)),
      DateTime.now().add(Duration(days: 5))
    ];

    _tabController = TabController(vsync: this, length: TAB_LENGTH);
    _tabController.index = 1;
    _tabController.addListener(() { 

      RestaurantService model = Provider.of<RestaurantService>(context, listen: false);

      Future.delayed(const Duration(milliseconds: 500), () async {
        var randomNumber = Random().nextInt(10);
        if (randomNumber < RestaurantTemplate().fullAdRandom) return;

        if ( randomNumber % 2 == 0 ) {
          Ads().showFullAd();
        } else {

          if ( await model.isShowPrivateFullAd()) {
            _showCustomAdDialog();
            model.saveShowPrivateAdDate();
          } else {
            Ads().showFullAd();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }


  _showCustomAdDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AdDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Consumer<RestaurantService>(

          builder: (context, model, _) {

            if ( model.isError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error_outline, color: Colors.red, size: 48.0,),
                    SizedBox(height: 64,),
                    Text(model.errorMessage, style: TextStyle(color: Colors.red.shade400),),
                    SizedBox(height: 32,),
                    RaisedButton(
                      child: Text('다시시도'),
                      onPressed: () {
                        model.load();
                      },
                    )
                  ],
                ),
              );
            }


            if ( model.busy) {
              return Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              controller: _tabController,
              children: List.generate(TAB_LENGTH, 
                          (index) => _buildFoodListPage(model.getSelectedRestaurant, index)
                        ),
            );
          }
        ),
      ),
    );
  }


  Widget _buildAppBar() {

    RestaurantService model = Provider.of<RestaurantService>(context, listen: false);

    return AppBar(
      //--------------------------
      title: FlatButton(
        onPressed: () => {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return RestaurantModalBottomSheet(
                    onSelected: (index) {
                      RestaurantService serviceModel = Provider.of<RestaurantService>(context, listen: false);
                      //FoodMenuModel model = Provider.of<FoodMenuModel>(this.context, listen: false);
                      this.setState(() {
                      });
                    },
                  );
                }
              );
            },
          )
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text(
                model.getRestaurantName,
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
      //--------------------------
      actions: <Widget>[
        _buildChatActionButton(model.chatRestaurant),
        _buildNtBestActionButton(),
        _buildBusActionButton(),
      ],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: Color(0xffFBA81F),
        indicatorWeight: 2,
        labelColor: Color(0xffFBA81F),
        //----------------------------
        tabs: List.generate(TAB_LENGTH, (index) 
                => Tab(text: _getTabHeaderText(index),)),
      ),
      //--------------------------
    );
  }


  ///
  /// 채팅 ( 게시판 )
  ///
  Widget _buildChatActionButton(Restaurant res) {
    return IconButton(
      icon: Icon(
        Icons.chat,
        semanticLabel: 'chat',
        color: Colors.white,
      ),
      onPressed: () {
        if (res == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext _context) {
              return FoodChatScreen(restaurant: res,);
            }
          )
        );
      },
    );
  }


  ///
  /// 눈팅베스트
  ///
  Widget _buildNtBestActionButton() {
    return IconButton(
      icon: Icon(
        Icons.insert_emoticon,
        semanticLabel: 'nbest',
        color: Colors.white,
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext _context) => TopReadListScreen()
          )
        );

        if (Random().nextInt(8) < RestaurantTemplate().fullAdRandom) return;
        Ads().showFullAd();
      },
    );
  }


  ///
  /// 버스
  ///
  Widget  _buildBusActionButton() {
    return IconButton(
      icon: Icon(
        Icons.directions_bus,
        semanticLabel: 'bus',
      ),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext _context) {
            //todo - Provider<BusService> ==> BusMainScreen 클래스 안으로 넣자.
            return Provider<BusService>(
              create: (context) => BusService(),
              dispose: (context, busService) => {},
              child: BusMainScreen());
        }));
      },
    );
  }


  ///
  /// 탭 타이틀
  ///
  String _getTabHeaderText(int index) {
    DateTime pageDate = _pagedate[index];

    if (pageDate.day == DateTime.now().day){
      return "오늘";
    }

    initializeDateFormatting("ko_KR");
    
    var formatter = DateFormat('MM.dd (E)', 'ko_KR');
    return formatter.format(pageDate);
  }


  ///
  /// 식단 리스트
  ///
  Widget _buildFoodListPage(Restaurant selectedRes, int index) {

    DateTime dt = _pagedate[index];

    if ( selectedRes.id == 0) {
      // Multi view
      return FoodMultipleMenuPage(dt);
    } else {
      //Single view
      return FoodMenuPage(
        selectedRes, 
        dt, 
        key: ValueKey('${selectedRes.id}$index'),
      );
    }
  }

}
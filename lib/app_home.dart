import 'dart:math';
import 'package:foodmenu_hdhardwork/RestaurantSelectView.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/food_multiple_menu_page.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/topReadListScreen.dart';
import 'package:foodmenu_hdhardwork/screen/restaurant/restaurant_empty_view.dart';
import 'package:foodmenu_hdhardwork/service/ads.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:foodmenu_hdhardwork/utils/restaurant_template.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_view.dart';
import 'package:provider/provider.dart';
import 'bus/bus_main_screen.dart';
import 'bus/bus_service.dart';
import 'screen/chat/food_chat_screen.dart';
import 'service/ads.dart';

class FoodNoteHome extends StatefulWidget {
  //FoodNoteHome();

  static const String routeName = '/FoodNoteHome';

  @override
  State<StatefulWidget> createState() {
    return _FoodNoteHomeState();
  }
}

class _FoodNoteHomeState extends State<FoodNoteHome>
    with SingleTickerProviderStateMixin, RouteAware {
  _FoodNoteHomeState();

  ScrollController _scrollViewController;
  TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final int tabLength = 7;
  List<DateTime> _pagedate = [
    DateTime.now().add(Duration(days: -1)),
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 4)),
    DateTime.now().add(Duration(days: 5))
  ];

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: tabLength);
    // 탭의 인덱스는 오늘 날짜로 세팅
    _tabController.index = 1;
    _tabController.addListener(() {
      // if (_tabController.index < 3) return;
      Future.delayed(const Duration(milliseconds: 1500), () {
        var randomNumber = Random().nextInt(10);
        if (randomNumber < RestaurantTemplate().fullAdRandom) return;
        Ads().showFullAd();
      });
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      var randomNumber = Random().nextInt(10);
      if (randomNumber < RestaurantTemplate().fullAdRandom) return;
      Ads().showFullAd();

    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantService = Provider.of<RestaurantService>(context);
    return Scaffold(
        appBar: AppBar(
            // backgroundColor: Colors.red,
            title: FlatButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                      return Provider.value(
                          value: restaurantService,
                          child: RestaurantModalBottomSheet(
                            onSelected: (index) {
                              this.setState(() {
                                // restaurantService.setRestaurantAndReorder(index);
                              });
                            },
                          ));
                    });
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    restaurantService.getRestaurantName,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey[400],
              indicatorColor: Color(0xffFBA81F),
              indicatorWeight: 2,
              labelColor: Color(0xffFBA81F),
              tabs: <Tab>[
                Tab(
                  text: _getTabHeader(_pagedate[0]),
                ),
                Tab(
                  text: _getTabHeader(_pagedate[1]),
                ),
                Tab(
                  text: _getTabHeader(_pagedate[2]),
                ),
                Tab(
                  text: _getTabHeader(_pagedate[3]),
                ),
                Tab(
                  text: _getTabHeader(_pagedate[4]),
                ),
                Tab(
                  text: _getTabHeader(_pagedate[5]),
                ),
                Tab(
                  text: _getTabHeader(_pagedate[6]),
                ),
              ],
              controller: _tabController,
            ),
            actions: <Widget>[

              IconButton(
                icon: Icon(
                  Icons.chat,
                  semanticLabel: 'chat',
                  color: Colors.white,
                ),
                onPressed: () {
                  if (restaurantService.chatRestaurant == null) return;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext _context) {
                            return FoodChatScreen(restaurant: restaurantService.chatRestaurant,);
                          }
                        )
                      );
                  
                                if (Random().nextInt(10) < RestaurantTemplate().fullAdRandom)
                    return;
                  Ads().showFullAd();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.insert_emoticon,
                  semanticLabel: 'nbest',
                  color: Colors.white,
                ),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext _context) =>
                              TopReadListScreen()));

                  if (Random().nextInt(10) < RestaurantTemplate().fullAdRandom)
                    return;
                  Ads().showFullAd();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.directions_bus,
                  semanticLabel: 'bus',
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext _context) {
                    return Provider<BusService>(
                        create: (context) => BusService(),
                        dispose: (context, busService) => {},
                        child: BusMainScreen());
                  }));
                },
              )
            ]),
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        body: SafeArea(
            top: false,
            child: TabBarView(
                children: <Widget>[
                  getScreen(context, _pagedate[0]),
                  getScreen(context, _pagedate[1]),
                  getScreen(context, _pagedate[2]),
                  getScreen(context, _pagedate[3]),
                  getScreen(context, _pagedate[4]),
                  getScreen(context, _pagedate[5]),
                  getScreen(context, _pagedate[6]),
                ],
                controller: _tabController,
              ),
            ));
  }

  String _getTabHeader(DateTime pageDate) {
    if (pageDate.day == DateTime.now().day){
      return "오늘";
    }
    initializeDateFormatting("ko_KR");
    var formatter = DateFormat('MM.dd (E)', 'ko_KR');
    return formatter.format(pageDate);
  }

  //
  // BottomNavigationBar 인덱스별로 화면을 가져온다.
  //
  getScreen(BuildContext _context, DateTime pageDate) {
    final restaurantService = Provider.of<RestaurantService>(context);
    if (restaurantService.getSelectedRestaurant == null) {
      return RestaurantEmptyView();
    }

    if (restaurantService.isNeedPasswordRestaurant()) {
      return _buildLockScreen(context);
    }

    if ( restaurantService.getSelectedRestaurant.id == 0) {
      return FoodMultipleMenuPage(pageDate);
    } else {
      return FoodMenuView(
        restaurant: restaurantService.getSelectedRestaurant,
        pageDate: pageDate,
      );
    }

  }

  Widget _buildLockScreen(BuildContext _context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock_outline,
              size: 180.0,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 98.0,
            ),
          ],
        ),
      ),
    );
  }
}

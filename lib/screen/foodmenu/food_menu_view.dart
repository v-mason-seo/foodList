import 'dart:async';

import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_meal_card_view.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/service/user_service.dart';
import 'package:foodmenu_hdhardwork/utils/utils.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:scroll_to_index/scroll_to_index.dart';

class FoodMenuView extends StatefulWidget {
  FoodMenuView({Key key, this.restaurant, this.pageDate}) : super(key: key);

  final Restaurant restaurant;
  final DateTime pageDate;

  @override
  FoodMenuState createState() {
    return FoodMenuState();
  }
}

/*---------------------------------------------*/

class FoodMenuState extends State<FoodMenuView> {
  // RefreshIndicator를 사용하기 위해서는 키가 필요함.
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  /// 생성자
  FoodMenuState({Key key});

  LoadingState _loadingState = LoadingState.LOADING;
  bool isLoading = false;
  // List<FoodItem> items = <FoodItem>[];
  FoodMenu foodMenu;

  AutoScrollController controller;

  @override
  void initState() {
    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
      // suggestedRowHeight: MediaQuery.of(context).size.height
    );

    super.initState();
    _loadNextPage();
  }

  @override
  void didUpdateWidget(FoodMenuView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.restaurant != null &&
        widget.restaurant != null &&
        widget.restaurant.id != oldWidget.restaurant.id) {
      _loadingState = LoadingState.LOADING;
      isLoading = false;
      foodMenu = null;
      _loadNextPage();
    } 
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _loadNextPage() async {
    if (widget.restaurant == null) return null;

    // print("restaurant id : ${widget.restaurant.id}");

    isLoading = true;
    // items.clear();
    foodMenu = null;

    try {
      var formatter = new DateFormat('yyyyMMdd');
      var pageDateString = formatter.format(widget.pageDate);
      var foodVo = await Api().loadFood(widget.restaurant, pageDateString);
      setState(() {
        _loadingState = LoadingState.DONE;

        foodMenu = foodVo;


        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        if (this.mounted) {
          setState(() => _loadingState = LoadingState.ERROR);
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {

    if (widget.pageDate.day == DateTime.now().day){
    WidgetsBinding.instance.addPostFrameCallback((context) async {
     
      int position = UserService().getCurrentTimeIndex();
      await controller.scrollToIndex( position,
          preferPosition: AutoScrollPosition.begin);
      controller.highlight(position);
    });
    }


    switch (_loadingState) {
      case LoadingState.DONE:
        return Container(
            child: RefreshIndicator(
                child: ListView.builder(
                  // scrollDirection: Axis.vertical,
                  // itemCount: foodMenu.mealList.length,
                  controller: controller,
                  itemCount: foodMenu.mealList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final meal = foodMenu.mealList[index];
                    return AutoScrollTag(
                        key:  ValueKey<int>(index) ,
                        controller: controller,
                        index: index,
                        child: FoodMenuMealCardView(
                          meal: meal,
                        ));
                  },
                ),
                onRefresh: _loadNextPage));
      case LoadingState.ERROR:
        return _buildErrorCard();
      case LoadingState.LOADING:
        return _buildProgressIndicator();
      default:
        return Container();
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorCard() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '아직 식단이 없네요...',
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 26.0,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}

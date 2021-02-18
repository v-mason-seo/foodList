import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodmenu_hdhardwork/ad/ad_card.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_meal_card_view.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_model.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:foodmenu_hdhardwork/service/user_service.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';


class FoodMenuPage extends StatelessWidget {

  Restaurant selectedRes;
  DateTime pageDate;

  FoodMenuPage(
    this.selectedRes,
    this.pageDate,
    {Key key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BaseWidget<FoodMenuModel>(
        model: FoodMenuModel(selectedRes, pageDate),
        onModelReady: (model) => model.loadData(),
      builder: (context, model, _) {
        
        if ( model.busy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if ( model.item == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return FoodMenuList(model.pageDate);
      },
    );
  }
}


class FoodMenuList extends StatefulWidget {

  final DateTime pageDate;

  FoodMenuList(
    this.pageDate, {
    Key key,
  }) : super(key: key);

  @override
  _FoodMenuListState createState() => _FoodMenuListState();

}

class _FoodMenuListState extends State<FoodMenuList> {


  final scrollDirection = Axis.vertical;
  AutoScrollController controller;

  @override
  void initState() {
    super.initState();

    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async { 

      if (widget.pageDate.day == DateTime.now().day){
        int position = UserService().getCurrentTimeIndex();

        if ( position > 0 ) {
          await controller.scrollToIndex( position, preferPosition: AutoScrollPosition.begin);
          controller.highlight(position);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    FoodMenuModel model = Provider.of<FoodMenuModel>(context, listen : false);
    RestaurantService serviceModel = Provider.of<RestaurantService>(context, listen: false);
    int position = UserService().getCurrentTimeIndex();

     return RefreshIndicator(
      //-------------------------------
      onRefresh: model.refreshData,
      //-------------------------------
      child: ListView.builder(
        scrollDirection: scrollDirection,
        controller: controller,
        // 개인 광고 노출 여부가 true 경우 +1을 해준다.
        itemCount: serviceModel.isEnablePrivateAd()
                    ? model.item.mealList.length+1
                    : model.item.mealList.length,
        itemBuilder: (context, index) {

          // 개인 광고는 맨 마지막에 삽입한다.
          if ( serviceModel.isEnablePrivateAd() && model.item.mealList.length == index) {
            return AdCard();
          }

          final meal = model.item.mealList[index];

          return AutoScrollTag(
            key:  ValueKey<int>(index) ,
            index: index,
            controller: controller,
            child: FoodMenuMealCardView(
              meal: meal,
              isSelected: ( widget.pageDate.day == DateTime.now().day && position == index ),
            ),
          );
        }
      ),
      //-------------------------------
    );
  }

}
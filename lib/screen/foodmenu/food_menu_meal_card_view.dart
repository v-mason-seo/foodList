import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_item_card_view.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';
import 'package:foodmenu_hdhardwork/utils/theme.dart';

class FoodMenuMealCardView extends StatefulWidget {
  final MealVo meal;
  final Color menuBackgrouldColor = randomColor();
  final bool isSelected;

  FoodMenuMealCardView({Key key, this.meal, this.isSelected = false}) : super(key: key);

  _FoodMenuMealCardViewState createState() => _FoodMenuMealCardViewState();
}

class _FoodMenuMealCardViewState extends State<FoodMenuMealCardView> {

  Widget _buildContainer() {

    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //side: BorderSide(color: widget.menuBackgrouldColor, width: 3.0)
          side: widget.isSelected 
                ? BorderSide(color: widget.menuBackgrouldColor, width: 3.0)
                : BorderSide.none
        ),
        //color: widget.menuBackgrouldColor,
        color: Colors.white,
        elevation: 2.4,
        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: widget.menuBackgrouldColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                )
              ),
              child: Center(
                child: Text(
                  widget.meal.category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    letterSpacing: 2.0,
                    fontFamily: 'BMHANNAAir',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          // 3. 식단리스트
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: FoodMenuItemCardView(dietList: widget.meal.data,),
          )
        ],
      )
    )
  );
  }

  @override
  Widget build(BuildContext context) {

    return _buildContainer();
  }
}
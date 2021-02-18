import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_model.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/utils/restaurant_template.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:intl/intl.dart';

class FoodMultipleMenuModel extends BaseModel {


  final DateTime pageDate;
  List<Pair> itemList;

  FoodMultipleMenuModel(this.pageDate);


  Future loadData() async {

    setBusy(true);

    Restaurant restaurant1 = RestaurantTemplate().restaurantList[0];
    Restaurant restaurant2 = RestaurantTemplate().restaurantList[1];
    
    FoodMenu foodMenu1 = await Api().loadFood(restaurant1, getDateString(pageDate));
    FoodMenu foodMenu2 = await Api().loadFood(restaurant2, getDateString(pageDate));

    if ( itemList == null) {
      itemList = [];
    } else {
      itemList.clear();
    }

    bindCategory(foodMenu1.mealList, foodMenu2.mealList);

    setBusy(false);
  }


  String getDateString(DateTime date) {
    var formatter = new DateFormat('yyyyMMdd');
    return formatter.format(date);
  }


  void bindCategory(List<MealVo> left, List<MealVo> right) {

    int leftLength = left == null ? 0 : left.length;
    int rightLength = right == null ? 0 : right.length;
    int length = max(leftLength, rightLength);

    for ( var i = 0 ; i < length; i++) {
      
      MealVo leftItem = (left != null && left.length > i) ? left[i] : null;
      MealVo rightItem = (right != null && right.length > i) ? right[i] : null;

      Pair pair = Pair();
      if ( leftItem != null && rightItem != null) {

        pair.left = MenuCategory.category(leftItem.category);
        pair.right = MenuCategory.category(rightItem.category);

      } else if ( leftItem != null && rightItem == null) {

        pair.left = MenuCategory.category(leftItem.category);
        pair.right = MenuCategory.empty();
        
      } else if ( leftItem == null && rightItem != null) {
        
        pair.left = MenuCategory.empty();
        pair.right = MenuCategory.category(rightItem.category);

      } else {
        pair.left = MenuCategory.empty();
        pair.right = MenuCategory.empty();
      }

      Pair resultPair = bindSubCategory(leftItem?.data, rightItem?.data);
      pair.left.items.addAll(resultPair.left);
      pair.right.items.addAll(resultPair.right);
      itemList.add(pair);
    }
  }

  Pair bindSubCategory(List<DietVo> left, List<DietVo> right) {


    List<MenuItem> leftContainer = [];
    List<MenuItem> rightContainer = [];

    int leftLength = left == null ? 0 : left.length;
    int rightLength = right == null ? 0 : right.length;
    int length = max(leftLength, rightLength);

    for ( var i = 0 ; i < length; i++) {
      
      DietVo leftItem = (left != null && left.length > i) ? left[i] : null;
      DietVo rightItem = (right != null && right.length > i) ? right[i] : null;

      if ( leftItem != null && rightItem != null) {
        leftContainer.add(MenuItem.subCategory(leftItem.title));
        rightContainer.add(MenuItem.subCategory(rightItem.title));
      } else if ( leftItem != null && rightItem == null) {
        leftContainer.add(MenuItem.subCategory(leftItem.title));
        rightContainer.add(MenuItem.emptySubCategory(MenuType.subCategory));
      } else if ( leftItem == null && rightItem != null) {
        leftContainer.add(MenuItem.emptySubCategory(MenuType.subCategory));
        rightContainer.add(MenuItem.subCategory(rightItem.title));
      } else {
        leftContainer.add(MenuItem.emptySubCategory(MenuType.subCategory ));
        rightContainer.add(MenuItem.emptySubCategory(MenuType.subCategory ));
      }

      Pair pairItem = bindMenu(leftItem?.itmes, rightItem?.itmes);
      leftContainer.addAll(pairItem.left);
      rightContainer.addAll(pairItem.right);
    }
   

    Pair pair = Pair();
    pair.left = leftContainer;
    pair.right = rightContainer;

    return pair;
  }

  Pair bindMenu(List<String> left, List<String> right) {

    List<MenuItem> leftContainer = [];
    List<MenuItem> rightContainer = [];
    int length = max(left?.length??0, right?.length??0);

    for ( var i = 0 ; i < length; i++ ) {

      String l = (left != null && left.length > i) ? left[i] : null;
      String r = (right != null && right.length > i) ? right[i] : null;

      
      if ( l != null && r != null) {
        
        leftContainer.add(MenuItem.item(l));
        rightContainer.add(MenuItem.item(r));
        
      } else if ( l != null && r == null) {
        
        leftContainer.add(MenuItem.item(l));
        rightContainer.add(MenuItem.empty(MenuType.item));
        
      } else if ( l == null && r != null) {
        
        leftContainer.add(MenuItem.empty(MenuType.item));
        rightContainer.add(MenuItem.item(r));
        
      } else {
        leftContainer.add(MenuItem.empty(MenuType.item));
        rightContainer.add(MenuItem.empty(MenuType.item));
      }
    }

    Pair pair = Pair();
    pair.left = leftContainer;
    pair.right = rightContainer;

    return pair;

  }
}

enum MenuType {category, subCategory, item, empty}

class MenuCategory{

  String title;
  MenuType type;
  final TextStyle textStyle;
  final EdgeInsets padding;
  List<MenuItem> items = [];


  MenuCategory.category(
    this.title, {
      this.type = MenuType.category
    }
  ) : textStyle = TextStyle(
        //color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        fontFamily: 'BMHANNAAir',
      ),
      padding = const EdgeInsets.only(top: 36.0, left: 8.0, bottom: 8.0)
      ;  

    MenuCategory.empty(
    {
      this.title = "-",
      this.type = MenuType.item
    }
  ) : textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        fontFamily: 'BMHANNAAir',
      ),
      padding = const EdgeInsets.only(top: 4.0, left: 24.0, bottom: 4.0)
      ;
  }


class MenuItem {
  String title;
  MenuType type;
  final TextStyle textStyle;
  final EdgeInsets padding;

  // MenuItem.category(
  //   this.title, {
  //     this.type = MenuType.category
  //   }
  // ) : textStyle = TextStyle(
  //       color: Colors.black,
  //       fontWeight: FontWeight.bold,
  //       fontSize: 24.0,
  //       fontFamily: 'BMHANNAAir',
  //     ),
  //     padding = const EdgeInsets.only(top: 36.0, left: 8.0, bottom: 8.0)
  //     ;

  MenuItem.subCategory(
    this.title, {
      this.type = MenuType.subCategory
    }
  ) : textStyle = TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        fontFamily: 'BMHANNAAir',
      ),
      padding = const EdgeInsets.only(top: 4.0, left: 4.0, bottom: 8.0)
      ;

  MenuItem.emptySubCategory(
    MenuType menuType,
    {
      this.title = "*",
      this.type = MenuType.item
    }
  ) : textStyle = TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        fontFamily: 'BMHANNAAir',
      ),
      padding = const EdgeInsets.only(top: 4.0, left: 4.0, bottom: 8.0)
      ;

  MenuItem.item(
    this.title, {
      this.type = MenuType.item
    }
  ) : textStyle = TextStyle(
        fontSize: 14.0,
        color: Colors.black87
      ),
      padding = const EdgeInsets.only(top: 0.0, left: 12.0, bottom: 0.0)
      ;

  MenuItem.empty(
    MenuType menuType,
    {
      this.title = "-",
      this.type = MenuType.item
    }
  ) : textStyle = TextStyle(
        fontSize: 14.0,
        color: Colors.black87
      ),
      padding = const EdgeInsets.only(top: 4.0, left: 12.0, bottom: 0.0)
      ;

}

class Pair {
  //Pair(this.left, this.right);

  dynamic left;
  dynamic right;

  @override
  String toString() => 'Pair[$left, $right]';
}
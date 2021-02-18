import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


abstract class FoodItem {}

class FoodHeader implements FoodItem {
  final String heading;

  FoodHeader(this.heading);

  String getHeading() {

    DateTime datetime = DateTime.parse(heading);
    var formatter = new DateFormat('MM.dd (E)');
    return formatter.format(datetime);
  }

  Color getHeadingColor() {
    DateTime datetime = DateTime.parse(heading);
    var formatter = new DateFormat('E');

    if ( formatter.format(datetime) == "Sat") {
      return Colors.blue[400];
    } else if (formatter.format(datetime) == "Sun") {
      return Colors.red[400];
    } else {
      return Colors.brown[900];
    }
  }
}

class FoodMenu {

  final String id;
  final List<MealVo> mealList;

  FoodMenu({this.id, this.mealList});

  factory FoodMenu.fromJson(Map<String, dynamic> json) {

    var list = json['mealList'] as List;
    List<MealVo> mealList = list.map((i) => MealVo.fromJson(i)).toList();

    return FoodMenu(
      id: json['_id'] as String,
      mealList: mealList
    );
  }
}

class MealVo  {

  final String category;
  final List<DietVo> data;

  //임시변수
  String date;

  MealVo({this.category, this.data});

  factory MealVo.fromJson(Map<String, dynamic> json){

    var list = json['data'] as List;
    List<DietVo> dietList = list.map((i) => DietVo.fromJson(i)).toList();

    return MealVo(
        category:json['category'],
        data: dietList
    );
  }
}

class DietVo {

  final String title;
  final List<String> itmes;

  DietVo({this.title, this.itmes});

  String getDietItmes() {

    String ret = "";

    if ( itmes == null ) {
      return ret;
    }

    for (int i=0; i < itmes.length; i++) {
      ret += " - " + itmes[i] + "\n";
    }

    return ret;
  }

  factory DietVo.fromJson(Map<String, dynamic> json){
    var streetsFromJson = json['items'];
    List<String> streetsList = streetsFromJson.cast<String>();

    return DietVo(
        title: json['title'],
        itmes: streetsList
    );
  }
}
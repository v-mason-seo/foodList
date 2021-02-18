import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_model.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:intl/intl.dart';

class FoodMenuModel extends BaseModel {

  Restaurant selectedRestaurant;
  DateTime pageDate;
  FoodMenu item;

  FoodMenuModel(this.selectedRestaurant, this.pageDate);

  Future loadData() async {

    //setBusy(true);

    //item = await Api().loadFood(selectedRestaurant, getDateString(pageDate));
    item = await Api().loadFood(selectedRestaurant, getDateString(pageDate));

    //setBusy(false);
    notifyListeners();

  }


  Future refreshData() async {

    item = null;
    notifyListeners();
    item = await Api().loadFood(selectedRestaurant, getDateString(pageDate));
    await Future.delayed(Duration(milliseconds: 500));

    notifyListeners();
  }


  String getDateString(DateTime date) {
    var formatter = new DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

}
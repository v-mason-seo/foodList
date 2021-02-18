import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/ad/ad_card.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/food_multiple_menu_model.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:provider/provider.dart';

class FoodMultipleMenuPage extends StatelessWidget {

  final DateTime pageDate;

  FoodMultipleMenuPage(this.pageDate, {
    Key key,
  }) : super(key: key);


 @override
 Widget build(BuildContext context)  {

   RestaurantService serviceModel = Provider.of<RestaurantService>(context, listen: false);

    return Stack(
      children: <Widget>[
        BaseWidget<FoodMultipleMenuModel>(
          model: FoodMultipleMenuModel(pageDate),
          onModelReady: (model) => model.loadData(),
          builder: (context, model, _) {

            if ( model.busy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Stack(
              children: <Widget>[
                // Container(
                //   color: Colors.grey[50],
                // ),
                //-----------------------------------------
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //-----------------------------------------
                    _buildTitle(),
                    //-----------------------------------------
                    Expanded(
                      child: _buildMainContent(model.itemList, serviceModel?.appConfig?.showPrivateAd),
                    ),
                    //-----------------------------------------
                  ],
                ),
              ],
            );
          },
        )
      ],
    );    
  }


  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        //------------------------------------------------
        _buildTitleItem("현장", Colors.yellow.shade600),
        //------------------------------------------------
        _buildTitleItem("숙소", Colors.green),
        //------------------------------------------------
      ],
    );
  }


  Widget _buildTitleItem(String title, Color color) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: color,
              width: 4.0
            )
          )
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          )
        ),
      ),
    );
  } 


  Widget _buildMainContent(List<Pair> items, bool showAdCard) {

    if ( showAdCard == null)
      showAdCard = false;
   
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      //separatorBuilder: (_, index) => Divider(),
      itemCount: showAdCard ? items.length + 1 : items.length,
      itemBuilder: (context, index) {

        if ( showAdCard && index == items.length) {
          return AdCard();
        }

        return Row(
          children: <Widget>[
            //----------------------------------
            //1. 현장 메뉴
            _buildMenuList(items[index].left, Colors.yellow[50],),
            //----------------------------------
            //2. 숙소 메뉴
            _buildMenuList(items[index].right, Colors.lightGreen[50],),
            //----------------------------------
          ],
        );
      }
    );
  }


  Widget _buildMenuList(dynamic item, Color cardBgColor) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: item.padding,
              child: Text(
                "${item.title}",
                //"\n ${items[index].left.items.length}",
                style: item.textStyle,
              ),
            ),
            Card(
              margin: const EdgeInsets.only(
                top: 4.0,
                left: 3.0,
                right: 3.0,
                bottom: 8.0,
              ),
              color: cardBgColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0,
                   top: 12.0, bottom: 12.0
                ),
                child: ListView.separated(
                  separatorBuilder: (_, index) => Divider(color: Colors.grey[300],),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: item.items.length,
                  itemBuilder: (context, k) {
                    MenuItem data = item.items[k];
                    return _buildMenuItem(data);
                  }
                ),
              ),
            )
          ],
        )
      ),
    );
  }


  Widget _buildMenuItem(MenuItem data) {
    return Container(
      height: 29.8,
      padding: data.padding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "${data.title}",
            style: data.textStyle,
        ),
      ),
    );
    // return Padding(
    //   padding: data.padding,
    //   child: Text(
    //       "${data.title}",
    //       style: data.textStyle,
    //   ),
    // );
  }
}
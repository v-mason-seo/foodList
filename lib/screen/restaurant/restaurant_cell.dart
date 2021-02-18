
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';

class RestaurantCell extends StatelessWidget {
  final Restaurant restaurant;
   final Restaurant currentRestaurantVo;
  const RestaurantCell({Key key, this.restaurant, this.currentRestaurantVo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          color: ( this.currentRestaurantVo != null && restaurant.id == currentRestaurantVo.id) ? Colors.lightBlue[50] : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.restaurant),
            //------------------------------------------
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(restaurant.name),
                SizedBox(width: 12.0,),
                // 패스워드가 있는 경우는 자물쇠 아이콘을 보여준다.
                (restaurant.password != null && restaurant.password.isNotEmpty) ? Icon(Icons.lock, size: 18.0, color: Colors.grey[600],) : SizedBox()
              ],
            ),
            //------------------------------------------
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.people),
                SizedBox(width: 12.0,),
                Text('${restaurant.userCount}')
              ],
            ),
            onTap: () {
              Navigator.pop(context, restaurant);
            },
            //onTap: () => onRestaurantVoTap(vo),
            //selected: vo.id == currentRestaurantVo.id ? true : false,
          ),
        ),
        Divider(),
      ],
    );
  }
}
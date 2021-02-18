import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmenu_hdhardwork/screen/restaurant/restaurant_list_screen.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:provider/provider.dart';

///
/// 선택한 식당이 없을때 보여주는 화면
///

class RestaurantEmptyView extends StatelessWidget {
  // const name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final RestaurantService restaurantService = Provider.of<RestaurantService>(context);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              size: 180.0,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 98.0,
            ),
            RaisedButton(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '식당찾기',
                style: TextStyle(
                  fontSize: 24.0,
                  //color: Colors.grey[800]
                ),
              ),
              onPressed: () async {
                final selectedRestaurant = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => RestaurantListScreen(
                            currentRestaurantVo: restaurantService.getSelectedRestaurant,
                          )),
                );

                if (selectedRestaurant != null) {
                  restaurantService.addRestaurant(selectedRestaurant);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

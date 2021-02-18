import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:provider/provider.dart';

import 'service/ads.dart';
import 'utils/theme.dart';
// import 'package:foodmenu_hdhardwork/screen/restaurant/restaurant_list_screen.dart';

class RestaurantModalBottomSheet extends StatefulWidget {
  final Function onSelected;
  RestaurantModalBottomSheet({Key key, @required this.onSelected});

  @override
  _RestaurantModalBottomSheetState createState() => _RestaurantModalBottomSheetState();
}

class _RestaurantModalBottomSheetState extends State<RestaurantModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final RestaurantService restaurantService = Provider.of<RestaurantService>(context);

    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        color: Colors.transparent,
        //margin: EdgeInsets.only(bottom: Ads().getMargin(MediaQuery.of(context).size.height)),
        child: SafeArea(
          child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    //color: Color(0xffFBA81F),
                    color: Colors.green,
                    child: ListTile(
                      leading: Icon(Icons.search, color: Colors.transparent),
                      title: Text(
                        '식당 선택',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      trailing: GestureDetector(
                        child: Icon(Icons.close, color: Colors.white),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: restaurantService.getRestaurantList.length,
                        itemBuilder: (_context, index) {
                          bool isCheckedItem;
                          (restaurantService.getRestaurantFromList(index) != null &&
                                  restaurantService.getSelectedRestaurant != null &&
                                  restaurantService.getRestaurantFromList(index).id ==
                                      restaurantService.getSelectedRestaurant.id)
                              ? isCheckedItem = true
                              : isCheckedItem = false;

                          return Column(
                            children: <Widget>[
                              // Dismissible(
                              //   background: Container(
                              //     alignment: Alignment.centerRight,
                              //     padding: EdgeInsets.only(right: 20.0),
                              //     color: Colors.red,
                              //     child: Icon(
                              //       Icons.delete,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   key: ObjectKey(
                              //       restaurantService.getRestaurantFromList(index)),
                              //   confirmDismiss:
                              //       (DismissDirection direction) async {
                              //     if (restaurantService.getSelectedRestaurant ==
                              //         restaurantService.getRestaurantFromList(index)) {
                              //       return false;
                              //     }
                              //     return true;
                              //   },
                              //   onDismissed: (direction) {
                              //         restaurantService.removeRestaurant(index);
                              //   },
                              //   child: ListTile(
                              //       title: Text(
                              //           ' ${restaurantService.getRestaurantFromList(index).name}'),
                              //       leading: CircleAvatar(
                              //         child: isCheckedItem
                              //             ? Icon(Icons.check)
                              //             : Icon(Icons.restaurant),
                              //         backgroundColor: isCheckedItem
                              //             ? mainTintColor
                              //             : Colors.grey[350],
                              //         foregroundColor: Colors.white,
                              //       ),
                              //       onTap: () {
                              //         //restaurantService.setRestaurantAndReorder(index);
                              //         restaurantService.setSelectRestaurantAndSave(index);
                              //         Navigator.pop(context);
                              //         widget.onSelected(index);
                              //       }),
                              // ),
                              ListTile(
                                    title: Text(
                                        ' ${restaurantService.getRestaurantFromList(index).name}'),
                                    leading: CircleAvatar(
                                      child: isCheckedItem
                                          ? Icon(Icons.check)
                                          : Icon(Icons.restaurant),
                                      backgroundColor: isCheckedItem
                                          ? mainTintColor
                                          : Colors.grey[350],
                                      foregroundColor: Colors.white,
                                    ),
                                    onTap: () {
                                      //restaurantService.setRestaurantAndReorder(index);
                                      restaurantService.setSelectRestaurantAndSave(index);
                                      Navigator.pop(context);
                                      widget.onSelected(index);
                                    }),
                              Divider()
                            ],
                          );
                        }),
                  ),
                ],
              )),
        ));
  }
}

//
// 식당선택 화면에서 선택한 식당으로 데이터 변경 -> 화면을 다시 그린다.
//
// _navigateAndSelection(BuildContext context) async {
  
//   final RestaurantService restaurantService = Provider.of<RestaurantService>(context);

//   final selectedRestaurant = await Navigator.push(
//     context,
//     MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => RestaurantListScreen(
//               currentRestaurantVo: restaurantService.getSelectedRestaurant ,
//             )),
//   );

//   if (selectedRestaurant != null) {
//     restaurantService.addRestaurant(selectedRestaurant);
//   }
// }

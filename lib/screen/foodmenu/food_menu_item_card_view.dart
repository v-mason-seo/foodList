import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/menu_view.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';

class FoodMenuItemCardView extends StatefulWidget {
  final List<DietVo> dietList;
  FoodMenuItemCardView({Key key, this.dietList}) : super(key: key);

  _FoodMenuItemCardViewState createState() => _FoodMenuItemCardViewState();
}

class _FoodMenuItemCardViewState extends State<FoodMenuItemCardView> {


  @override
  void initState() {
    super.initState();

  }

  List<Widget> getBody() {
    List<Widget> body = List<Widget>();

    if (widget.dietList.length == 0){
      body.add( 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text("메뉴가 없네요", style: TextStyle(fontSize: 18)),
        ),
      );
      return body;
    }
    widget.dietList.forEach((diet) {
      body.add( 
        MenuView(menu:diet,)
        );
      body.add(SizedBox(height: 15,));
    });
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...getBody()
        ],
      );
    // 2. 식단표 카드
  }
}


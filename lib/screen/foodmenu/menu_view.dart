import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmenu_hdhardwork/vo/foodMenu.dart';

class MenuView extends StatefulWidget {
  final DietVo menu;
  MenuView({Key key, this.menu}) : super(key: key);

  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  
  List<Widget> getBody() {
    List<Widget> body = List<Widget>();
    widget.menu.itmes.forEach((item) {
      body.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Text(
            item,
            softWrap: true,
            style: TextStyle(fontSize: 17/*, color: Colors.white*/),
            )
          )
        );
      }
    );

    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5,),
          Text(
            widget.menu.title,
            style: TextStyle(
                fontSize: 24,
                color: Colors.black54,
                fontFamily: 'BMHANNAAir',
                fontWeight: FontWeight.w700
            )
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 10, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[...getBody()],
            ),
          )
        ],
      )
    );
  }
}

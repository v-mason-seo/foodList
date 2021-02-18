import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/model/item.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/report_screen.dart';
import 'package:foodmenu_hdhardwork/screen/ntbest/siteLogo.dart';
import 'package:url_launcher/url_launcher.dart';

TextStyle textColor(String key) {
  // HistoryManager().isRead(key).then( (result) => {
  //   if (result == false){
  //     return TextStyle(color: Colors.black);
  //   }

  //   return TextStyle(color: Colors.black);
  // });
  return TextStyle(color: Colors.black);
}

TextStyle rankingColor(int ranking) {
  switch (ranking) {
    case 1:
      return TextStyle(color: Colors.purple[800], fontSize: 25);
      break;
    case 2:
      return TextStyle(color: Colors.purple[600], fontSize: 25);
    case 3:
      return TextStyle(color: Colors.purple[400], fontSize: 25);
    default:
      return TextStyle(color: Colors.black54);
  }
}

Widget topReadCell(BuildContext context, Item item, int index) {
  return ListTile(
    leading: siteLogo(item.sid),//Text(index.toString(), style: rankingColor(index)),
          title: 
      (item.deleteCount ?? 0) > 0 ?
      Text("[신고 ${item.deleteCount ?? 0}]" + item.title , style: TextStyle(color: Colors.redAccent)):
      Text(item.title),
    trailing: ButtonTheme(
        minWidth: 35.0,
        child: FlatButton(
          child: Text(
            '신고',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () async {
            Navigator.push(context, 
             MaterialPageRoute(
                fullscreenDialog: true,
              builder: (context) =>
                ReportScreen(content: item)
              ));
          },
        ),
      ),
    onTap:  () async
    {
          if (await canLaunch(item.url)) {
      await launch(item.url, forceSafariVC: true, forceWebView: false);
    } else {
      // throw 'Could not launch $url';
    }
    }
  );
}

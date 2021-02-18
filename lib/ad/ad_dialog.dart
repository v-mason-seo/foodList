import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDialog extends StatelessWidget {

  final String imagePath = 'assets/image/full_380_640.jpg';

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height * 0.8;
    double w = MediaQuery.of(context).size.height * 0.95;

    return Dialog(
      child: Container(
        width: w,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {
                  _launchInBrowser();
                },
                child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage(imagePath),
                  ),
              ),
            ),
            //---------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('닫기', style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchInBrowser() async {
    var url = 'http://bweye.co.kr/event1/?ref=food';

    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }
}
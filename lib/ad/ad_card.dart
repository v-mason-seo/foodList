import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AdCard extends StatelessWidget {

  String imagePath;

  AdCard({
    this.imagePath = 'assets/image/card_400_240.jpg'
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: GestureDetector(
          onTap: () {
            _launchInBrowser();
          },
          child: Image(
              fit: BoxFit.contain,
              image: AssetImage(imagePath),
            ),
        ),
      )
    );
  }


  void _launchInBrowser() async {
    var url = 'http://bweye.co.kr/event1/?ref=food';

    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


class SettingsScreen extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  Future<Null> launched;

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('설정', style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 50.0),
          child: ListView(
            children: <Widget>[
              //               ListTile(
              //   leading: Icon(Icons.person),
              //   title: Text('로그인', ),
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext _context) => LoginScreen()));
              //   },
              // ),
              // Divider(),
              ListTile(
                leading: Icon(Icons.lightbulb_outline),
                title: Text('테마(다크)', ),
                trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (isDark) {
                      if ( isDark) {
                        DynamicTheme.of(context).setBrightness(Brightness.dark);
                      } else {
                        DynamicTheme.of(context).setBrightness(Brightness.light);
                      }
                    }
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('개인정보처리방침', ),
                onTap: () {
                  //String url = "https://s3.ap-northeast-2.amazonaws.com/food.nunting.kr/privacy_hdfoodlist.html";
                  launched = _launchInBrowser('https://s3.ap-northeast-2.amazonaws.com/food.nunting.kr/privacy_hdfoodlist.html');
                },
              ),
              Divider(),
            ],
          ),
        )
    );
  }
}


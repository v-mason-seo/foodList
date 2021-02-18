import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/service/user_service.dart';

class LoginScreen extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  void login(String email, String pw) async{
    var res = await Api().login (email, pw);
          if ( res.statusCode == 201 ) {
            
          }
          //print(res);
  }
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: '4',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: _email,
    );

    final password = TextFormField(
      autofocus: false,
      // initialValue: '4',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: _password,

    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {

          var res = await Api().login (email.controller.text, password.controller.text);
          if ( res.statusCode == 201 ) {
            UserService().setAccessKey("accesskey");
            return ;
          }
          //print(res);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('식당 관리자 로그인', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        '비밀번호를 잊으셨나요?',
        style: TextStyle(color: Colors.grey),
      ),
      onPressed: () {},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      // backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          // shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
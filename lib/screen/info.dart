// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utils/theme.dart';


// class FoodInfoScreen extends StatefulWidget {

//   @override
//   _FoodInfoState createState() => _FoodInfoState();

// }

// class _FoodInfoState extends State<FoodInfoScreen> {

//   Future<Null> launched;

//   Future<Null> _launchInBrowser(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url, forceSafariVC: false, forceWebView: false);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('정보')
//       ),
//       body: Container(
//         padding: EdgeInsets.only(bottom: 50.0),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [kShrinePink100, kShrinePink300],
//           )
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.0),
//           child: CustomScrollView(
//             slivers: <Widget>[
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   <Widget>[
//                     //----------------------------------------------------------
//                     InfoListSection(
//                       title: '샘플데이터입니다.',
//                       child: Text('공지사항 및 이용안내 데이터 입력을 하시면 아래와 같이 화면에 표시됩니다.'),
//                     ),
//                     //----------------------------------------------------------
//                     InfoListSection(
//                       title: '공지사항',
//                       child: Column(
//                         children: <Widget>[
//                           ListTile(
//                             title: Text('공사일정', style: TextStyle(fontSize: 18.0),),
//                             subtitle: Text('더 나은 식당이용을 위하 공사를 진행할 예정입니다.\n - 일정 : 2018.10.26 ~ 2018.11.23\n이용에 불편을 드려 죄송합니다.'),
//                             trailing: Text('오늘'),
//                           ),
//                           Divider(height: 12.0,),
//                           ListTile(
//                             title: Text('이벤트 안내', style: TextStyle(fontSize: 18.0),),
//                             subtitle: Text('식당이용 후 후기를 등록하신분에게 특별한 행운이 쏟아집니다. 많은 이용부탁드립니다.'),
//                             trailing: Text('어제'),
//                           ),
//                           Divider(height: 12.0,),
//                           ListTile(
//                             title: Text('공지2', style: TextStyle(fontSize: 18.0),),
//                             subtitle: Text('식당이용 후 후기를 등록하신분에게 특별한 행운이 쏟아집니다. 많은 이용부탁드립니다.'),
//                             trailing: Text('4일전'),
//                           ),
//                           Divider(height: 12.0,),
//                           Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               new FlatButton(
//                                   onPressed: () {
//                                   },
//                                   child: Text('더보기', style: TextStyle(color: kShrinePink400))),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //----------------------------------------------------------
//                     InfoListSection(
//                       title: '이용안내',
//                       child: Column(
//                         children: <Widget>[
//                           ListTile(
//                             leading: CircleAvatar(
//                               child: Text('조식', style: TextStyle(color: Colors.grey[100]),),
//                               backgroundColor: Colors.brown[400],
//                             ),
//                             title: Text('06:00 ~ 10:30'),
//                             //subtitle: Text('06:00 ~ 10:30'),
//                           ),
//                           Divider(height: 1.0,),
//                           ListTile(
//                             leading: CircleAvatar(
//                               child: Text('중식', style: TextStyle(color: Colors.grey[100]),),
//                               backgroundColor: Colors.brown[500],
//                             ),
//                             title: Text('11:30 ~ 13:30'),
//                           ),
//                           Divider(height: 1.0,),
//                           ListTile(
//                             leading: CircleAvatar(
//                               child: Text('석식', style: TextStyle(color: Colors.grey[100]),),
//                               backgroundColor: Colors.brown[700],
//                             ),
//                             title: Text('17:00 ~ 19:00'),
//                           ),
//                           Divider(height: 1.0,),
//                           ListTile(
//                             leading: CircleAvatar(
//                               child: Text('야식', style: TextStyle(color: Colors.grey[100]),),
//                               backgroundColor: Colors.brown[900],
//                             ),
//                             title: Text('21:30 ~ 23:00'),
//                           ),
//                           Divider(height: 1.0,),
//                         ],
//                       ),
//                     ),
//                     //----------------------------------------------------------
//                     InfoListSection(
//                       title: '식당 연락처',
//                       child: Column(
//                         children: <Widget>[
//                           ListTile(
//                             title: Text(
//                               '02-1234-5678',
//                             ),
//                             subtitle: Text('전화'),
//                             onTap: () {
//                             },
//                           ),
//                           Divider(height: 1.0,),
//                           ListTile(
//                             title: Text(
//                               'restaurant12@xxx.com',
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   decoration: TextDecoration.underline
//                               ),
//                             ),
//                             subtitle: Text('Email'),
//                             onTap: () {
//                               launched = _launchInBrowser('mailto:<restaurant12@xxx.com>');
//                             },
//                           ),
//                           Divider(height: 1.0,),
//                         ],
//                       ),
//                     ),
//                     //----------------------------------------------------------
//                     InfoListSection(
//                       title: '개발자 연락처',
//                       child: Column(
//                         children: <Widget>[
//                           ListTile(
//                             title: Text(
//                               'ddastudio14@gmail.com',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 decoration: TextDecoration.underline
//                               ),
//                             ),
//                             subtitle: Text('Email'),
//                             onTap: () {
//                               launched = _launchInBrowser('mailto:<ddastudio14@gmail.com>');
//                             },
//                           ),
//                           Divider(height: 1.0,),
//                           ListTile(
//                             title: Text(
//                               'https://open.kakao.com/o/gUPG3e1',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                   decoration: TextDecoration.underline
//                               ),
//                             ),
//                             subtitle: Text('카카오오픈채팅'),
//                             onTap: () {
//                               launched = _launchInBrowser('https://open.kakao.com/o/gUPG3e1');
//                             },
//                           ),
//                           Divider(height: 1.0,),
//                         ],
//                       ),
//                     )
//                     //----------------------------------------------------------
//                   ]
//                 )
//               )
//             ],
//           ),
//         )
//       ),
//     );
//   }
// }



// class InfoListSection extends StatelessWidget {
//   InfoListSection({this.title, this.imagePath, this.child});

//   final String title;
//   final String imagePath;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {

//     return Card(
//       margin: EdgeInsets.all(12.0),
//       elevation: 8.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             DefaultTextStyle(
//               style: Theme.of(context).textTheme.subhead,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8.0, left: 8.0),
//                 child: Text(
//                   title,
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.5)
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: child,
//             )
//           ],
//         ),
//       ),
//     );
//   }


// }
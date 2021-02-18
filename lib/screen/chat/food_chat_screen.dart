import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodmenu_hdhardwork/screen/chat/chat_manage_page.dart';
import 'package:foodmenu_hdhardwork/screen/chat/chat_page.dart';
import 'package:foodmenu_hdhardwork/service/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:foodmenu_hdhardwork/vo/boardVo.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../setting/setting_screen.dart';



class FoodChatScreen extends StatefulWidget {

  Restaurant restaurant;

  FoodChatScreen({Key key, @required this.restaurant}) : super(key: key);

  @override
  FoodChatScreenState createState() => FoodChatScreenState();
}



class FoodChatScreenState extends State<FoodChatScreen> {
 
  
  GlobalKey<ChatPageState> _keyChild1 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "현대중공업 게시판",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.lock, color: Colors.transparent,),
            onLongPress: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatManagePage(restaurant: widget.restaurant,)
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () async {
              if (await canLaunch("http://www.hhiun.or.kr/rules")) {
                await launch("http://www.hhiun.or.kr/rules",
                    forceSafariVC: true, forceWebView: false);
              }
            },
          ),
          //--------------------------------
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SettingsScreen()
              ));
            },
          ),
        ],
      ),
      //--------------------------------
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

          _keyChild1.currentState.onWirtePressed();
          // _keyChild1.currentState.updateText("Update from Parent");
          return;
          //return _showInputDialog(context);
        }, 
        label: Text("글쓰기"),
        icon: Icon(Icons.create),
        backgroundColor: Colors.green,
      ),
      //--------------------------------
      body: ChatPage(
        key: _keyChild1,
        restaurant: widget.restaurant,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Restaurant restaurant;
  const ChatScreen({this.restaurant});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  // RefreshIndicator를 사용하기 위해서는 키가 필요함.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<BoardVo> boardList = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _nickNameTextController = TextEditingController();
  bool _isComposiing = false;
  bool _isLoading = false;
  bool _isEndData = false;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    _textController.dispose();
    _nickNameTextController.dispose();
    super.dispose();
  }

  Future<Null> loadData() async {
    _isEndData = false;
    boardList?.clear();
    _isLoading = false;

    _isLoading = true;
    try {
      final repos = await Api().loadBoardList(widget.restaurant.id);
      setState(() {
        if (repos != null) {
          boardList = repos;
        }
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
    }

    return null;
  }

  void loadMoreData(int offset) async {
    if (_isEndData) return;

    _isLoading = true;
    try {
      final repos =
          await Api().loadBoardList(widget.restaurant.id, offset: offset);

      if (repos.length == 0) _isEndData = true;

      setState(() {
        if (repos != null) {
          boardList == null ? boardList = repos : boardList.addAll(repos);
        }
      });
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
    }
  }

  ///
  /// 이미 신고한 건인지 확인
  ///
  Future<bool> isAvailableReport(int bid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myReportRecord = prefs.getString("my_report_record");

    if ( myReportRecord == null)
      return true;

    return !myReportRecord.contains(bid.toString());
  }


  ///
  /// 중복 신고를 하지 못하도록 신고한 글 id를 저장한다.
  ///
  Future recordReport(int bid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myReportRecord = prefs.getString("my_report_record");

    if ( myReportRecord == null || myReportRecord == "") {
      prefs.setString("my_report_record", bid.toString());
    } else {
      prefs.setString("my_report_record", myReportRecord + ",$bid");
    }
  }


  Widget _showPopupMenu(BoardVo board) => PopupMenuButton<int>(
    onSelected: (value) async {
      
      if ( await isAvailableReport(board.bid) ) {
        Api().reportBoardContent(board);
        setState(() {
          board.reported = board.reported + 1;
        });
        await recordReport(board.bid);
        Fluttertoast.showToast(
          msg: "신고되었습니다.",
          gravity: ToastGravity.TOP
        );
      } else {
        Fluttertoast.showToast(
          msg: "이미 신고건입니다.",
          gravity: ToastGravity.TOP
        );
      }
      
    },
    itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("신고하기"),
        ),
      ],
    );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                child: ListView.builder(
                  //padding: EdgeInsets.all(8.0),
                  itemCount: boardList.length,
                  itemBuilder: (context, int index) {
                    if (!_isEndData &&
                        !_isLoading &&
                        index > (boardList.length * 0.7)) {
                      loadMoreData(boardList.length);
                    }
                    return _buildChatRow(boardList[index]);
                  },
                ),
                onRefresh: loadData)),
        Divider(
          height: 12.0,
          thickness: 2,
        ),
        // SizedBox(height: 10,),
        SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        )
      ],
    );
  }

 Widget _buildChatRow(BoardVo board) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        board.reported > 5
            ? FlatButton(
                child: Text(
                  board.reported.toString() + " 건 신고 된 내용입니다. \n그래도 보실려면 눌러주세요",
                ),
                onPressed: () {
                  setState(() {
                    board.reported = 0;
                  });
                },
              )
            : ListTile(
                trailing: _showPopupMenu(board),
                title: Text(
                  board.body,
                  style: TextStyle(fontSize: 16.0),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        board.writer,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.green[500]
                                    : Colors.green[600],
                            fontSize: 12.0),
                      )),
                      Text(
                        board.getTimeAgo(),
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[400]
                                    : Colors.grey[300],
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
        Divider()
      ],
    );
  }
  ///
  /// 글 작성 레이아웃
  ///
  Widget _buildTextComposer() {
    return FutureBuilder(
      future: UserService().getNickName(),
      initialData: "익명",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        _nickNameTextController.text = snapshot.data;

        return IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: SafeArea(
              child: Container(
                  // color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: Row(children: <Widget>[
                        Icon(Icons.person),
                        SizedBox(width: 8.0,),
                        Flexible(
                            child: TextField(
                                maxLines: 1,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: '닉네임',
                                  contentPadding: EdgeInsets.all(2),
                                  border: InputBorder.none,
                                ),
                                controller: _nickNameTextController,
                                onChanged: (value) {
                                  UserService().updateNickName(
                                      _nickNameTextController.text);
                                },
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.green[500]
                                        : Colors.green[600],
                                    fontSize: 14.0))),
                      ])),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              controller: _textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              maxLength: 150,
                              onChanged: (String text) {
                                setState(() {
                                  _isComposiing = text.length > 0;
                                });
                              },
                              onSubmitted: _handleSubmitted,
                              decoration: InputDecoration(
                                hintText: "글쓰기",
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: _isComposiing
                                  ? () => _handleSubmitted(_textController.text)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ));
      },
    );
  }

  ///
  /// 전송버튼 클릭
  ///
  void _handleSubmitted(String text) async {
    _textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isComposiing = false;
    });

    var res = await Api()
        .createBoard(widget.restaurant.id, _nickNameTextController.text, text);
    if (res.statusCode == 201) {
      loadData();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmenu_hdhardwork/screen/chat/chat_custom_dialog.dart';
import 'package:foodmenu_hdhardwork/screen/chat/chat_model.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/vo/boardVo.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_alert/status_alert.dart';




class ChatPage extends StatefulWidget {

  final Restaurant restaurant;

  ChatPage({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  ChatModel chatModel;  

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ChatModel>(
      model: ChatModel(restaurant: widget.restaurant),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, _) {

        chatModel = model;

        if ( model.isError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.error_outline, color: Colors.red, size: 48.0,),
                SizedBox(height: 64,),
                Text(model.errorMessage, style: TextStyle(color: Colors.red.shade400),),
                SizedBox(height: 32,),
                RaisedButton(
                  child: Text('다시시도'),
                  onPressed: () {
                    model.loadData();
                  },
                )
              ],
            ),
          );
        }


        return model.busy
          ? Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
              onRefresh: () => model.loadRefreshData(),
              //child: Container(color: Colors.green,),
              child: _buildMainContent(model),
          );
      },
    );
  }


  ///
  /// 게시글 리스트 ( 메인 )
  ///
  Widget _buildMainContent(ChatModel model) {
    
    return ListView.separated(
      separatorBuilder: (_, index) => Divider(),
      itemCount: model.items.length == 0 ? 0 : model.items.length,
      itemBuilder: (context, index) {
        //print("index : $index");

        // if ( index == 3 ) {
        //   return AdCard(imagePath: 'assets/image/banner_400_50.jpg',);
        // }

        if ( !model.loadMoreDataProcessing && index > (model.items.length * 0.7)) {
          model.loadMoreData(model.items.length);
        }

        BoardVo item = model.items[index];

        return _bildChatRow(model, item);
      }
    );
  }

  Widget _bildChatRow(ChatModel model, BoardVo item){


    // 신고 게시글
    if ( item.reported > 5) {

      String lockMessage = 
        "${item.reported}건 신고 된 내용입니다.\n그래도 보실려면 자물쇠 버튼을 눌러주세요";

      return ListTile(
        //----------------------------------
        leading: IconButton(
          icon: item.forceVisible == false
                ? FaIcon(FontAwesomeIcons.lock, /*color: Colors.black87,*/)
                : FaIcon(FontAwesomeIcons.unlock, /*color: Colors.black87*/),
          onPressed: () => model.setForceVisible(item),
        ),
        //----------------------------------
        title: item.forceVisible == false 
                ? Text(lockMessage, style: TextStyle(/*olor: Colors.black45,*/ fontSize: 13.0), )
                : Text(item.body, style: TextStyle(/*color: Colors.black45,*/  decoration: TextDecoration.lineThrough, decorationThickness: 4), ),
        //----------------------------------
        subtitle : item.forceVisible
          ? Row(
              children: <Widget>[
                Expanded(child: Text(item.writer, style: TextStyle(color: Colors.green[400], fontSize: 12.0),),),
                Text(item.getTimeAgo(), style: TextStyle(color: Colors.black45, fontSize: 12.0),),
              ],
            )
          : null,
        //----------------------------------
        trailing: _showReportPopupMenu(item),
        //----------------------------------
      );

    }


    // 정상 게시글
    return ListTile(
      //----------------------------------
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      //----------------------------------
      title: Text(item.body/*, style: TextStyle(color: Colors.black87),*/ ),
      //----------------------------------
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(item.writer, style: TextStyle(color: Colors.green[400], fontSize: 12.0),),),
            Text(item.getTimeAgo(), style: TextStyle(/*color: Colors.black45,*/ fontSize: 12.0),),
          ],
        ),
      ),
      //----------------------------------
      trailing: _showReportPopupMenu(item),
      //----------------------------------
    );

  }


  void onWirtePressed() {
    _showInputDialog(context);
  }

  _showInputDialog(BuildContext mainContext) {

    showDialog(
      context: mainContext,
      builder: (BuildContext ctx) {
        return ChatCustomDialog(
          onConfirm: (String nickName, String text) {
            if ( nickName == null || nickName.isEmpty) {
              StatusAlert.show(
                context,
                duration: Duration(seconds: 1),
                title: '입력오류',
                subtitle: "닉네임을 입력해주세요",
                configuration: IconConfiguration(icon: Icons.error),
              );

              return;
            }

            if ( text == null || text.isEmpty) {
              StatusAlert.show(
                context,
                duration: Duration(seconds: 1),
                title: '입력오류',
                subtitle: "내용을 입력해주세요",
                configuration: IconConfiguration(icon: Icons.error),
              );

              return;
            }

            chatModel?.insertNewItem(nickName, text);
          },
        );
      }
    );
  }






  Widget _showReportPopupMenu(BoardVo board) => PopupMenuButton<int>(
    onSelected: (value) async {
      
    if ( await isAvailableReport(board.bid) ) {
      Api().reportBoardContent(board);
      // setState(() {
      //   board.reported = board.reported + 1;
      // });
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
}
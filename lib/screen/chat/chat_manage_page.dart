import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/screen/chat/chat_model.dart';
import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_widget.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/vo/boardVo.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';




class ChatManagePage extends StatefulWidget {

  final Restaurant restaurant;

  ChatManagePage({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  _ChatManagePageState createState() => _ChatManagePageState();
}

class _ChatManagePageState extends State<ChatManagePage> {

  ChatModel chatModel;  
  bool isPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시글 관리", style: TextStyle(color: Colors.white),),
      ),
      body: BaseWidget<ChatModel>(
        model: ChatModel(restaurant: widget.restaurant),
        onModelReady: (model) => model.loadData(),
        builder: (context, model, _) {

          chatModel = model;

          if ( isPass == false) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 48.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onSubmitted: (text) {
                    if ( text == "1120100") {
                      setState(() {
                        isPass = true;
                      });
                    } else {
                      Navigator.pop(context) ;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                  ),
                ),
              ),
            );
          }

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
      ),
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

        if ( !model.loadMoreDataProcessing && index > (model.items.length * 0.7)) {
          model.loadMoreData(model.items.length);
        }

        BoardVo item = model.items[index];

        return _bildChatRow(model, item);
      }
    );
  }

  Widget _bildChatRow(ChatModel model, BoardVo item){

    return ListTile(
      //----------------------------------
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      //----------------------------------
      leading: CircleAvatar(
        backgroundColor: item.reported > 5 ? Colors.red : null,
        foregroundColor: item.reported > 5 ? Colors.white : null,
        child: Center(
          child: Text(
            item.reported.toString(),
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ),
      //----------------------------------
      title: Text(item.body, style: TextStyle(color: Colors.black87), ),
      //----------------------------------
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(item.writer, style: TextStyle(color: Colors.green[400], fontSize: 12.0),),),
            Text(item.getTimeAgo(), style: TextStyle(color: Colors.black45, fontSize: 12.0),),
          ],
        ),
      ),
      //----------------------------------
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await Api().reportBoardContent(item);
          model.addReportCount(item);
          //model.loadData();
        },
      ),
      //----------------------------------
    );
  }
}
import 'package:flutter/material.dart';
import 'package:foodmenu_hdhardwork/service/user_service.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void ConfirmCallback(String nickName, String text);

class ChatCustomDialog extends StatefulWidget {

  final ConfirmCallback onConfirm;
  //final VoidCallback onCancel;

  ChatCustomDialog({
    this.onConfirm,
    //this.onCancel,
  });

  @override
  _ChatCustomDialog createState() => _ChatCustomDialog();
}

class _ChatCustomDialog extends State<ChatCustomDialog> {

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _nickNameTextController = TextEditingController();


  @override
  void initState() {
    super.initState();

    getNickName();
  }


  @override
  void dispose() {
    _textController?.dispose();
    _nickNameTextController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(),
    );
  }

  _buildDialogContent() {
    double h= MediaQuery.of(context).size.height * 0.5;
    return Container(
      //padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      //------------------------------
      height: h,
      decoration: BoxDecoration(
        //color: Colors.white,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      //------------------------------
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _buildInput(),
          ),
          _buildConfirmAndCancel(),
        ],
      ),
    );
  }


    Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 20.0,),
          Text("☝🏼 닉네임", style: TextStyle(fontWeight: FontWeight.bold/*, color: Colors.black*/, fontSize: 16.0),),
          Divider(),
          //------------------------------------
          TextField(
            controller: _nickNameTextController,
            style: TextStyle(
              color: Colors.green,
              fontSize: 14.0
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '닉네임을 입력해주세요'
            ),
          ),
          //------------------------------------
          SizedBox(height: 16.0,),
          //------------------------------------
          Text(
            "✌🏼 내용", 
            style: TextStyle(fontWeight: FontWeight.bold/*, color: Colors.black*/, fontSize: 16.0),
          ),
          Divider(),
          //------------------------------------
          TextField(
            style: TextStyle(
              fontSize: 14.0
            ),
            controller: _textController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '내용을 입력해주세요'
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildConfirmAndCancel() {
    return Row(
      children: <Widget>[
        //---------------------------------------------
        Expanded(
          flex: 1,
          child: GestureDetector(
            //-----------------------------
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0))
              ),
              child: Text("취소", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87),),
            ),
            //-----------------------------
            // 취소버튼 클릭시 창 종료
            onTap: () => Navigator.pop(context),
            //-----------------------------
          ),
        ),
        //---------------------------------------------
        Expanded(
          flex: 1,
          child: GestureDetector(
            //-----------------------------
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0))
              ),
              child: Text("입력", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            ),
            //-----------------------------
            onTap: () async {
              String nickName = _nickNameTextController.text;


              
              // 닉네임을 로컬에 저장
              if (nickName != null || !nickName.isEmpty) {
                UserService().updateNickName(nickName);
              }

              widget.onConfirm(_nickNameTextController.text, _textController.text);
              Navigator.pop(context);
            },
            //-----------------------------
          )
        ),
        //---------------------------------------------
      ],
    );
  }



  getNickName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nickname = prefs.getString('nickname');

    if (nickname == null) {
      String randomNickName = '익명${randomNumeric(4)}';
      prefs.setString('nickname', randomNickName);
    }

    _nickNameTextController.text = nickname;
  }

  
}
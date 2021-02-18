import 'package:foodmenu_hdhardwork/screen/food_multiple_menu/base_model.dart';
import 'package:foodmenu_hdhardwork/service/api.dart';
import 'package:foodmenu_hdhardwork/vo/boardVo.dart';
import 'package:foodmenu_hdhardwork/vo/restaurant.dart';

class ChatModel extends BaseModel {

  Restaurant restaurant;
  List<BoardVo> items = [];

  bool _isEndData = false;
  bool loadMoreDataProcessing = false;

  ChatModel({
    this.restaurant
  });


  ///
  ///
  ///
  Future loadData() async {

    items?.clear();

    try {
      items = await Api().loadBoardList(restaurant.id);
    } catch ( e ) {
      // print("-----------------------");
      // print(e);
      // print("-----------------------");
      setError(true, "게시글 로드중 오류가 발생했습니다.");
    }

    setBusy(false);

    return Future;
  }


  Future loadRefreshData() async {

    _isEndData = false;
    loadMoreDataProcessing = false;
    items?.clear();

    try {
      items = await Api().loadBoardList(restaurant.id);
    } catch ( e ) {
      setError(true, "게시글 로드중 오류가 발생했습니다.");
    }

    setBusy(false);

    return Future;
  }


  ///
  ///
  ///
  Future loadMoreData(int offset) async {

    print("[loadMoreData]");

    //if ( _isEndData ) return;

    loadMoreDataProcessing = true;

    try {

      final repos = await Api().loadBoardList(restaurant.id, offset: offset);
      if ( repos.length != 0) _isEndData = true;
      if ( repos != null || repos.length != 0 ) {
        items?.addAll(repos);
      }

    } catch (e) {
      loadMoreDataProcessing = false;
      setError(true, "게시글 로드중 오류가 발생했습니다.");
    }

    loadMoreDataProcessing = false;
    notifyListeners();
  }


  void setForceVisible(BoardVo item) {
    item.forceVisible = !item.forceVisible;
    notifyListeners();
  }

  void addReportCount(BoardVo item) {
    
    int cnt = item.reported;
    if ( cnt != null) {
      item.reported = cnt + 1;
    } else  {
      item.reported = 1;
    }
    notifyListeners();
  }

  void insertNewItem(String nickName, String text) async {
    var res = await Api()
        .createBoard(restaurant.id, nickName, text);

    if (res.statusCode == 201) {

      loadData();
    }
  }
}
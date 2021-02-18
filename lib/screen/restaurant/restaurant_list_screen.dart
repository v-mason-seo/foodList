import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../service/ads.dart';
import '../../vo/restaurant.dart';
import '../../service/api.dart';

class RestaurantListScreen extends StatefulWidget {

  final Restaurant currentRestaurantVo;

  const RestaurantListScreen({
    Key key,
    this.currentRestaurantVo,
  });

  @override
  State<StatefulWidget> createState() {
    return _RestaurantState(currentRestaurant: currentRestaurantVo);
  }
}

class _RestaurantState extends State<RestaurantListScreen> {

  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  Widget appBarTitle = new Text("식당선택", style: TextStyle(color: Colors.white));
  final Restaurant currentRestaurant;
  List<Restaurant> restaurantList = [];
  String selectedCategory = "전체";
  // List<String> categoryList = ['전체','초등','중고등','초중고','대학','오피스','산업체','관공서','병원','요양','복지','유아','영아','행사','기타'];
List<String> categoryList = ['전체','오피스','산업체','관공서','병원'];
  String _error;
  bool _isSearching = false;
  
  _RestaurantState({Key key, this.currentRestaurant});

  @override
  void initState() {
    super.initState();

    if (this.mounted){
      if ( _isSearching == false ) {
        loadData();
      }
    }

  }


  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    final repos = await Api().loadRestaurantList( selectedCategory, '');

    if (this.mounted){
      setState(() {
      if ( repos != null ) {
        restaurantList = repos;
      }
    });
    }
    
  }

  void performSearch(String query) async {

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = null;
        restaurantList = List();
      });
      return;
    }

    final repos = await Api().loadRestaurantList(selectedCategory, query);
    if (this.mounted) {
      setState(() {
        _isSearching = false;
        if (repos != null) {
          restaurantList = repos;
        } else {
          _error = 'Error searching repos';
        }
      });
    }
  }

  ///
  /// 식당 선택 스크린
  ///
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        // actions: <Widget>[
        //   IconButton(
        //     tooltip: "search",
        //     icon: actionIcon,
        //     onPressed: () {
        //       setState(() {
        //         if ( this.actionIcon.icon == Icons.search) {
        //           this.actionIcon = Icon(Icons.close);
        //           this.appBarTitle =
        //             TextField(
        //               autofocus: true,
        //               style: TextStyle(color: Colors.black),
        //               decoration: InputDecoration(
        //                 border: InputBorder.none,
        //                 labelStyle: TextStyle(
        //                     color: Colors.grey[900]
        //                 ),
        //                 prefixIcon: Padding(
        //                     padding: EdgeInsetsDirectional.only(end: 16.0),
        //                     child: Icon(
        //                       Icons.search,
        //                       color: Colors.grey[880],
        //                     )),
        //                 hintText: "식당명을 입력해주세요...",
        //                 hintStyle: TextStyle(color: Colors.grey[880])
        //               ),
        //               onSubmitted: (query) {
        //                 performSearch(query);
        //               },
        //             );
        //         } else {
        //           this.actionIcon = Icon(Icons.search);
        //           this.appBarTitle = Text('식당선택', style: TextStyle(color: Colors.white));
        //         }
        //       });
        //     },
        //   )
        // ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

          Expanded(
            child: _buildRestaurantBody()
          )
        ],
      ),
    );
  }

  Widget _buildRestaurantBody() {

    if (_isSearching) {
      return Center(
        child: Text("검색중"),
      );
    } else if ( _error != null ) {
      return Center(
        child: Text("데이터 로드중 오류가 발생했습니다."),
      );
    } else  {
      return _buildRestaurandList();
    }
  }

  ///
  /// 식당 리스트
  ///
  Widget _buildRestaurandList() {
    return ListView.builder(
      itemCount: restaurantList.length,
      itemBuilder: (context, index) {
        return _buildRow(context, restaurantList[index]);
      },
    );
  }

  ///
  /// 식당 아이템(로우)
  ///
  Widget _buildRow(BuildContext _context, Restaurant vo) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          color: (currentRestaurant != null && vo.id == currentRestaurant.id)
              ? Theme.of(context).selectedRowColor
              : Colors.transparent,
          child: ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(vo.name),
                SizedBox(width: 12.0,),
                // 패스워드가 있는 경우는 자물쇠 아이콘을 보여준다.
                (vo.password != null && vo.password.isNotEmpty)
                    ? Icon(Icons.lock, size: 18.0, color: Colors.grey[600],)
                    : SizedBox()
              ],
            ),
            onTap: () {
              Navigator.pop(_context, vo);
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}

/*-------------------------------------------------------------------*/

// class RestaurantList extends StatelessWidget {

//   final List<Restaurant> restaurantList;
//   final Restaurant currentRestaurantVo;
//   int value = 1;

//   RestaurantList({Key key, this.restaurantList, this.currentRestaurantVo}) :super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     return Container(
//       padding: EdgeInsets.only(bottom: 50.0),
//       child: ListView.builder(
//         itemCount: restaurantList.length,
//         itemBuilder: (context, index) {
//           return RestaurantCell(restaurant: restaurantList[index],currentRestaurantVo: currentRestaurantVo,);
//         },
//       )
//     );
//   }
// }

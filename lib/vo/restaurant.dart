

class Restaurant {
  final int id;
  final String name;
  final String password;
  final int userCount;
  final String extid;

  Restaurant({this.id, this.name, this.password, this.userCount, this.extid});

  String getImageUrl() {
    var restaurantId = (extid != null ? extid : id.toString());
    return "https://s3.ap-northeast-2.amazonaws.com/ddafoodlist/images/" + restaurantId + ".png";
  }

  String getLoadUri(String yyyymmdd) {
    var restaurantId = (extid != null ? extid : id.toString());
    
    return "https://s3.ap-northeast-2.amazonaws.com/ddafoodlist/" + restaurantId + "/" + yyyymmdd;
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['gid'],
      name: json['nm'] as String,
      password: json['pw'] as String,
      userCount: json['user_cnt'],
      extid: json['extid'] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'gid': id,
        'nm': name,
        'pw': password,
        'user_cnt': userCount,
        'extid': extid
      };

  @override
  bool operator ==(other) {
   return other is Restaurant && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
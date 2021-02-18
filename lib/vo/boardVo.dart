import 'package:timeago/timeago.dart' as timeago;

class BoardVo {

  int bid;
  String writer;
  final String body;
  String created;
  int reported;
  bool forceVisible = false;
  
  BoardVo({this.bid, this.writer, this.body, this.created, this.reported});

  getTimeAgo() {

    DateTime datetime;
    try {
      datetime = DateTime.parse(created);
    } catch (e) {
      datetime = DateTime.now();
    }
    
    return timeago.format(datetime, locale: 'ko');
  }

  factory BoardVo.fromJson(Map<String, dynamic> json) {
    return BoardVo(
      bid: json['bid'],
      writer: json['writer'] as String,
      body: json['body'] as String,
      created: json['created'] as String,
      reported: json['reported'] as int
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'bid': bid,
        'writer': writer,
        'body': body,
        'created': created,
        'reported': reported
      };
}
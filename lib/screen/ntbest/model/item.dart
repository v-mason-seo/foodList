class Item {
  final String sid;
  final String url;
  final String title;
  final int readCount;
  final int deleteCount;

  Item(this.sid, this.url, this.title, this.readCount, this.deleteCount);

  Item.fromJson(Map<String, dynamic> json)
      : sid = json['sid'],
        url = json['url'],
        title = json['title'],
        readCount = json['read_count'],
        deleteCount = json['delete_count'];

  Map<String, dynamic> toJson() =>
      {
        'sid': sid,
        'url': url,
        'title': title, 
        'read_count' : readCount,
        'delete_count' : deleteCount
      };
}
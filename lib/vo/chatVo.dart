class ChatResponse {
  final int totalRows;
  final int offset;
  final List<ChatRow> rows;

  ChatResponse({this.totalRows, this.offset, this.rows});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {

    var list = json['rows'] as List;
    List<ChatRow> rows = list.map((i) => ChatRow.fromJson(i)).toList();

    return ChatResponse(
        totalRows: json['total_rows'] as int,
        offset: json['offset'] as int,
        rows: rows
    );
  }
}

class ChatRow {

  final String id;
  final String key;
  final ChatValue value;

  ChatRow({this.id, this.key, this.value});

  factory ChatRow.fromJson(Map<String, dynamic> json) {

    return ChatRow(
      id: json['id'] as String,
      key: json['key'] as String,
      value: ChatValue.fromJson(json['value']),
    );
  }
}

class ChatValue {

  String id;
  String rev;
  String unm;
  String ment;
  String updt;

  ChatValue({this.id, this.rev, this.unm, this.ment, this.updt});

  factory ChatValue.fromJson(Map<String, dynamic> json) {
    return ChatValue(
      id: json['_id'] as String,
      rev: json['_rev'] as String,
      unm: json['unm'] as String,
      ment: json['ment'] as String,
      updt: json['updt'] as String,
    );
  }
}
class Site {
  final String id;
  final String nm;
  final String type;
  bool unwatching;

  Site(this.id, this.nm, this.type);

  Site.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nm = json['nm'],
        type = json['type'];

  Map<String, dynamic> toJson() => {'id': id, 'id': id, 'type': type};
}

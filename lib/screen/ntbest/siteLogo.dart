import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget siteLogo(String siteId) {
  return Padding(
    padding: EdgeInsets.only(right: 10),
    child: ClipOval(
      child: Image.network(
        "http://image.nunting.kr/$siteId.png",
        width: 35,
        fit: BoxFit.cover,
      ),
    ),
  );
}

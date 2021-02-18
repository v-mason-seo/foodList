import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  Provider.debugCheckInvalidValueType = null;
  runApp(new MyApp());
}

import 'dart:math';

import 'package:flutter/material.dart';

const mainTintColor = const Color(0xFF06AC50);
const subTintColor = Colors.orangeAccent;
const kShrinePink50 = const Color(0xFFFEEAE6);
const kShrinePink100 = const Color(0xFFFEDBD0);
const kShrinePink300 = const Color(0xFFFBB8AC);
const kShrinePink400 = const Color(0xFFEAA4A4);

//const kShrineBrown900 = const Color(0xFF442B2D);
const kShrineBrown900 = const Color(0xFF5D4037);
const kShrineBrown800 = const Color(0xFF5D4037);


const kShrineErrorRed = const Color(0xFFC5032B);

const kShrineSurfaceWhite = const Color(0xFFFFFBFA);
const kShrineBackgroundWhite = Colors.white;

const kRallyGreen = const Color(0xff1EB980);
const kRallyYellow = const Color(0xffFFCF44);

const kDarkPrimary = Color.fromRGBO(50, 56, 73, 1.0);
const kDarkBackgound = Color.fromRGBO(58, 66, 86, 1.0);
const kDarkCardBackground = Color.fromRGBO(64, 75, 96, .9);


const menuBackgroudColors =
[
  Color(0xff3d3d3d),
  Colors.redAccent,
  Colors.teal,
  Colors.pinkAccent,
  Colors.redAccent,
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.purple,
  Colors.deepPurple,
  Colors.blueGrey,
  Colors.brown,
  Color(0xFFee5253),
  Color(0xff485460),
  Color(0xff575fcf),
  Color(0xff6F1E51),
  Color(0xff273c75),
  Color(0xff8c7ae6),
  Color(0xff227093),
  Color(0xff84817a),
  Color(0xffff793f),
  Color(0xfff78fb3),
  Color(0xff45aaf2),
  Color(0xffeb3b5a),
  Color(0xff6ab04c),
  Color(0xfffa983a),
  Color(0xffeb2f06),
  Color(0xff78e08f)
];

Color randomColor(){

  return menuBackgroudColors[Random().nextInt(menuBackgroudColors.length)];
}
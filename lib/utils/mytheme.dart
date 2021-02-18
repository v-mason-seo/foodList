import 'theme.dart';
import 'package:flutter/material.dart';

class MyTheme {

  static ThemeData buildDartTheme() {

    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      accentColor: kRallyGreen,
      primaryColor: kDarkPrimary,
      buttonColor: kShrinePink100,
      scaffoldBackgroundColor: kDarkBackgound,
      cardColor: kDarkCardBackground,
      textSelectionColor: kShrinePink100,
      selectedRowColor: Colors.blue[700],
      errorColor: kShrineErrorRed,
      /*-----------------------------------------------*/
      indicatorColor: kRallyGreen,
      /*-----------------------------------------------*/
//      primaryIconTheme: base.iconTheme.copyWith(
//          color: kShrineBrown900
//      ),
      /*-----------------------------------------------*/
      textTheme: _buildDarkTextTheme(base.textTheme),
      primaryTextTheme: _buildDarkTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildDarkTextTheme(base.accentTextTheme),
    );
  }

  static TextTheme _buildDarkTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
          fontWeight: FontWeight.w500
      ),
      title: base.title.copyWith(
          fontSize: 19.0
      ),
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
      ),
    ).apply(
      displayColor: Colors.grey[100],
      bodyColor: Colors.grey[100],
    );
  }


  static ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      //accentColor: kShrineBrown900,
      accentColor: Colors.black87,
      primaryColor: mainTintColor,
      buttonColor: subTintColor,
      scaffoldBackgroundColor: kShrineBackgroundWhite,
      cardColor: kShrineBackgroundWhite,
      textSelectionColor: subTintColor,
      errorColor: kShrineErrorRed,
      /*-----------------------------------------------*/
      unselectedWidgetColor: Colors.grey[350],
      indicatorColor: kShrineBrown800,
      /*-----------------------------------------------*/
      primaryIconTheme: base.iconTheme.copyWith(
          color: Colors.white
      ),
      /*-----------------------------------------------*/
      textTheme: _buildShrineTextTheme(base.textTheme),
      primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    );
  }

  static TextTheme _buildShrineTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
          fontWeight: FontWeight.w500
      ),
      title: base.title.copyWith(
          fontSize: 19.0
      ),
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
      ),
    ).apply(
      displayColor: Colors.black87,
      bodyColor: Colors.black87,
    );
  }

}
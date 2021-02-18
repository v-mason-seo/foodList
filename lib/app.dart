
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:foodmenu_hdhardwork/food_home_page.dart';
import 'package:foodmenu_hdhardwork/screen/foodmenu/food_menu_model.dart';
import 'package:foodmenu_hdhardwork/service/ads.dart';
import 'package:foodmenu_hdhardwork/service/restaurant_service.dart';
import 'package:foodmenu_hdhardwork/utils/restaurant_template.dart';
import 'package:provider/provider.dart';
import 'utils/mytheme.dart';
import 'service/ads.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Ads().init();
    Ads().showBanner();
  }

  @override
  void dispose() {
    Ads().hideBanner();
    Ads().hideFullAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantService(),),
        //ChangeNotifierProvider(create: (_) => FoodMenuModel(),)
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) {
          return brightness == Brightness.light
              ? MyTheme.buildLightTheme()
              : MyTheme.buildDartTheme();
        },
        themedWidgetBuilder: (context, theme) {
          return Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: RestaurantTemplate().title,
              theme: theme,
              home: FoodNoteHomePage(),
            ),
          );
        },
      ),
    );
  }
}

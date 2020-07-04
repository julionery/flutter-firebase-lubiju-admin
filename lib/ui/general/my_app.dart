import 'package:flutter/material.dart';
import 'package:lubijuadmin/ui/general/login_page.dart';

Color color2 = Color(0xff721725);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorMap = {
      50: Color.fromRGBO(114, 23, 37, .1),
      100: Color.fromRGBO(114, 23, 37, .2),
      200: Color.fromRGBO(114, 23, 37, .3),
      300: Color.fromRGBO(114, 23, 37, .4),
      400: Color.fromRGBO(114, 23, 37, .5),
      500: Color.fromRGBO(114, 23, 37, .6),
      600: Color.fromRGBO(114, 23, 37, .7),
      700: Color.fromRGBO(114, 23, 37, .8),
      800: Color.fromRGBO(114, 23, 37, .9),
      900: Color.fromRGBO(114, 23, 37, 1),
    };
    MaterialColor customColor = MaterialColor(0xFF721725, colorMap);

    return MaterialApp(
      title: 'Lú Biju Admin',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: customColor,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

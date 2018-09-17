import 'package:flutter/material.dart';
import 'package:flutter_messenger/pages/home_page.dart';



// Todo
/*
final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final Theme iOSTheme = new Theme(
  data: new ThemeData(
    primarySwatch: Colors.red,
    primaryColor: Colors.grey[400],
    primaryColorBrightness: Brightness.dark,
  ),
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

final Theme androidTheme = new Theme(
  data: new ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.green,
  ),
);
*/

void main() {
  runApp(new MaterialApp(
    title: "Flutter Messenger",
    //theme: defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
    /*
    theme: new ThemeData(),
    // https://stackoverflow.com/questions/50625070/flutter-different-theme-for-android-and-ios
    builder: (context, child) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return iOSTheme;
      } else {
        return androidTheme;
      }
    },*/
    home: new HomePage(),
  ));
}
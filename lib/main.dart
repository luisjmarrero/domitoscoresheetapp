import 'package:domitoscoresheetapp/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Domino Score Sheet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemBlue.color,
          backgroundColor: CupertinoColors.systemGrey5.color,
          buttonColor: CupertinoColors.systemGreen.color,
          cardColor: CupertinoColors.systemGrey5.color,
          accentColor: Colors.blueAccent,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
            ),
            subtitle: TextStyle(color: Colors.black, fontSize: 20),
            body1: TextStyle(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.systemBlue.darkColor,
          buttonColor: CupertinoColors.systemGreen.darkColor,
          backgroundColor: CupertinoColors.systemGrey5.darkColor,
          cardColor: CupertinoColors.systemGrey5.darkColor,
          accentColor: Colors.blueAccent,
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white, fontSize: 20),
            subtitle: TextStyle(color: Colors.white, fontSize: 20),
            body1: TextStyle(color: Colors.white),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

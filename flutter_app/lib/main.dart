import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/main_screen.dart';


void main() => runApp(MaterialApp(
  theme:ThemeData (
    primarySwatch: Colors.orange,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orangeAccent,
    ),
  ),
  initialRoute: '/',
  routes: {
    '/': (context)=>MainScreen(),
    '/todo': (context)=>Home(),
  },
));








































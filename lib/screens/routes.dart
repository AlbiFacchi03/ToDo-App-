import 'package:flutter/material.dart';
import 'package:to_do_facchi/screens/components/body.dart';
import 'package:to_do_facchi/screens/home.dart';
import 'package:to_do_facchi/screens/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  Body.routeName: (context) => Body(),
  HomePage.routeName: (context) => HomePage(),
};
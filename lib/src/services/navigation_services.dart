import 'package:flutter/cupertino.dart';

class NavigationServices {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static navigateTo(String routename) {
    return navigatorKey.currentState!.pushNamed(routename);
  }

  static replaceTo(String routename) {
    return navigatorKey.currentState!.pushReplacementNamed(routename);
  }
}

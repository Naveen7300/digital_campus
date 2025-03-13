import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static String _currentRoute = '/';

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static void setCurrentRoute(String route) {
    _currentRoute = route;
  }

  static String getCurrentRoute() {
    return _currentRoute;
  }
}
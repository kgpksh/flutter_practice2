import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice2/views/home_page.dart';
import 'package:flutter_practice2/web_api_list/web_api_list.dart';

class AppRouter {
  Route? onGenerateroute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/webApiList':
        return MaterialPageRoute(builder: (_) => WebApiList());
      default:
        return null;
    }
  }
}

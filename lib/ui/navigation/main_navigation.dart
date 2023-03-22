import 'package:flutter/material.dart';

import '../login_page.dart';
import '../necessary_details_page.dart';
import '../purchases_list_screen.dart/purchases_list_page.dart';

abstract class AppRouteName {
  static const login = 'login';
  static const purList = '/';
  static const necDetails = '/necDetails';
}

class MainNavigation {
  static const initialRoute = AppRouteName.login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case AppRouteName.purList:
        return MaterialPageRoute(
            builder: (context) => const PurchasesListPage());
      case AppRouteName.necDetails:
        final arg = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => NecessaryDetailsPage(currentId: arg));

      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                body: Center(child: Text('Navigation error!!!'))));
    }
  }
}

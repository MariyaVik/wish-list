import 'package:flutter/material.dart';

import '../login_page.dart';
import '../necessary_details_page.dart';
import '../purchases_list_page.dart';

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
        return MaterialPageRoute(builder: (context) => LoginPage());
      case AppRouteName.purList:
        // final arg = settings.arguments as User;
        return MaterialPageRoute(
            builder: (context) => PurchasesListPage(
                // place: arg,
                ));
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

// class MapNestedNavigation {
//   static const initialRoute = AppNavRouteName.map;

//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case AppNavRouteName.map:
//         return MaterialPageRoute(builder: (context) => const MapPage());
//       case AppNavRouteName.placeDetails:
//         final arg = settings.arguments as Place;
//         return MaterialPageRoute(
//             builder: (context) => PlaceDetailsPage(place: arg));
//       case AppNavRouteName.eventDetails:
//         final arg = settings.arguments as Event;
//         return MaterialPageRoute(
//             builder: (context) => EventDetailsPage(currentEvent: arg));
//       case AppNavRouteName.roomDetails:
//         final arg = settings.arguments as Room;
//         return MaterialPageRoute(
//             builder: (context) => RoomDetailsPage(room: arg));

//       default:
//         return MaterialPageRoute(
//             builder: (context) => const Scaffold(
//                 body: Center(child: Text('Nested navigation error!!!'))));
//     }
//   }
// }

// class ProfNestedNavigation {
//   static const initialRoute = AppNavRouteName.profile;

//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case AppNavRouteName.profile:
//         return MaterialPageRoute(builder: (context) => const ProfilePage());

//       default:
//         return MaterialPageRoute(
//             builder: (context) => const Scaffold(
//                 body: Center(child: Text('Nested navigation error!!!'))));
//     }
//   }
// }

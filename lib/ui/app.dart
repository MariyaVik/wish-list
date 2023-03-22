import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/auth_state.dart';
import '../states/details_state.dart';
import '../states/purchases_state.dart';
import '../states/storage_state.dart';
import 'navigation/main_navigation.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PurchasesState>(
            create: (context) => PurchasesState()),
        ChangeNotifierProvider<AuthState>(create: (context) => AuthState()),
        ChangeNotifierProvider<DetailsState>(
            create: (context) => DetailsState()),
        ChangeNotifierProvider<StorageState>(
            create: (context) => StorageState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Necessary list',
        theme: themeLight,
        initialRoute: MainNavigation.initialRoute,
        onGenerateRoute: MainNavigation.onGenerateRoute,
      ),
    );
  }
}

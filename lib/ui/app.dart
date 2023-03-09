import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/necessary_details_model.dart';
import 'navigation/main_navigation.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NecessaryDetailsModel>(
          create: (context) => NecessaryDetailsModel(),
        ),
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

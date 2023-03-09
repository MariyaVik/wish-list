import 'package:flutter/material.dart';
import 'package:skillbox_17_8/ui/navigation/main_navigation.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('логин'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRouteName.purList);
              },
              child: Text('Войти'),
            )
          ],
        ),
      ),
    ));
  }
}

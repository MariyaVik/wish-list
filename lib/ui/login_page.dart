import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillbox_17_8/ui/navigation/main_navigation.dart';

import '../data/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthController>();
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await authProvider.signInWithGoogle();
                Navigator.of(context)
                    .pushReplacementNamed(AppRouteName.purList);
              },
              child: Text('Войти через гугл'),
            )
          ],
        ),
      ),
    ));
  }
}

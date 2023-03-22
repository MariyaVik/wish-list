import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/auth_state.dart';
import 'navigation/main_navigation.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthState>();
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await authProvider.signIn();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRouteName.purList);
                }
              },
              child: const Text('Войти через гугл'),
            )
          ],
        ),
      ),
    ));
  }
}

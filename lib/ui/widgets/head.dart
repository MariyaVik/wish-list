import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/auth_state.dart';
import '../navigation/main_navigation.dart';
import '../theme/theme.dart';

class Head extends StatelessWidget {
  const Head({super.key});

  final double avatarRadius = 40;

  @override
  Widget build(BuildContext context) {
    final AuthState authProvider = context.read<AuthState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: AppColor.orange,
            backgroundImage: NetworkImage(
                authProvider.user?.photoURL ?? 'assets/no_user.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Добро пожаловать,',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColor.backColor),
                ),
                Text(
                  authProvider.user?.displayName ?? 'Пользователь',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 20),
                )
              ],
            ),
          ),
          SizedBox(
            height: avatarRadius * 2,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                        color: AppColor.backColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.of(context)
                              .pushReplacementNamed(AppRouteName.login);
                        }
                      },
                      icon: const Icon(
                        Icons.exit_to_app_outlined,
                        color: AppColor.backColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

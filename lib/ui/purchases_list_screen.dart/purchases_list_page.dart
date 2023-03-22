import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/auth_state.dart';
import '../check_width.dart';
import 'phone_version.dart';
import 'web_version.dart';

class PurchasesListPage extends StatefulWidget {
  const PurchasesListPage({super.key});

  @override
  State<PurchasesListPage> createState() => _PurchasesListPageState();
}

class _PurchasesListPageState extends State<PurchasesListPage> {
  @override
  void initState() {
    super.initState();
    print('PurchasesListPage : INIT');
  }

  @override
  void dispose() {
    print('PurchasesListPage : DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('PurchasesListPage : BUILD');
    final authProvider = context.read<AuthState>();
    print('на экрпне юзер ${authProvider.user?.displayName}');
    return SafeArea(
        child: CurrentScreen.isDesktop(context)
            ? PurchaseListPageWeb()
            : PurchaseListPagePhone());
  }
}

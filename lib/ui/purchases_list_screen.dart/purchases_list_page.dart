import 'package:flutter/material.dart';
import '../check_width.dart';
import 'narrow_version.dart';
import 'wide_version.dart';

class PurchasesListPage extends StatelessWidget {
  const PurchasesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CurrentScreen.isDesktop(context)
            ? const PurchaseListPageWeb()
            : const PurchaseListPagePhone());
  }
}

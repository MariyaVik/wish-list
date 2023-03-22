import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filters.dart';
import '../states/auth_state.dart';
import '../states/details_state.dart';
import 'widgets/add_thing_widget.dart';
import 'widgets/filter_button.dart';
import 'widgets/necessary_details_widget.dart';

class NecessaryDetailsPage extends StatefulWidget {
  final int currentId;
  const NecessaryDetailsPage({required this.currentId, super.key});

  @override
  State<NecessaryDetailsPage> createState() => _NecessaryDetailsPageState();
}

class _NecessaryDetailsPageState extends State<NecessaryDetailsPage> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthState>().user;
    context
        .read<DetailsState>()
        .getPurchaseDetails(currentUser, widget.currentId);
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.read<DetailsState>();
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              detailsProvider.currentFilter = Filter.all;
              detailsProvider.filtredThings = [];
              detailsProvider.purchaseDetails = {};
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Consumer<DetailsState>(builder: (context, details, _) {
          return Text(details.purchaseDetails['name'] ?? '');
        }),
        actions: const [
          FilterButton(),
        ],
      ),
      body: const NecessaryDetailsWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: addThingDialog,
        child: const Icon(Icons.add),
      ),
    ));
  }

  void addThingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const AddThingWidget();
        });
  }
}

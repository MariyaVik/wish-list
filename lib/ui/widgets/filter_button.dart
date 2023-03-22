import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/filters.dart';
import '../../states/auth_state.dart';
import '../../states/details_state.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.read<DetailsState>();
    final currentUser = context.read<AuthState>().user;
    return PopupMenuButton(
      icon: const Icon(Icons.filter_alt),
      itemBuilder: (BuildContext context) => <PopupMenuItem<Filter>>[
        PopupMenuItem(
          value: Filter.all,
          child: const Text('Все'),
          onTap: () {
            if (detailsProvider.currentFilter != Filter.all) {
              detailsProvider.currentFilter = Filter.all;
              detailsProvider.filteringThings(currentUser);
            }
          },
        ),
        PopupMenuItem(
          value: Filter.done,
          child: const Text('Куплено'),
          onTap: () {
            if (detailsProvider.currentFilter != Filter.done) {
              detailsProvider.currentFilter = Filter.done;
              detailsProvider.filteringThings(currentUser);
            }
          },
        ),
        PopupMenuItem(
          value: Filter.undone,
          child: const Text('Нужно купить'),
          onTap: () {
            if (detailsProvider.currentFilter != Filter.undone) {
              detailsProvider.currentFilter = Filter.undone;
              detailsProvider.filteringThings(currentUser);
            }
          },
        ),
      ],
    );
  }
}

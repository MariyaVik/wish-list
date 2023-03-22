import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/storage_state.dart';

class NoSelectImage extends StatelessWidget {
  const NoSelectImage({super.key});

  @override
  Widget build(BuildContext context) {
    String imageUrl = context.read<StorageState>().imageUrl!;

    return Image.network(imageUrl);
  }
}

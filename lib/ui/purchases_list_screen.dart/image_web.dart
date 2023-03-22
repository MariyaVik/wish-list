import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/storage_state.dart';

class NoSelectImage extends StatelessWidget {
  const NoSelectImage({super.key});

  @override
  Widget build(BuildContext context) {
    String imageUrl = context.read<StorageState>().imageUrl!;
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%',
    );
    return HtmlElementView(
      viewType: imageUrl,
    );
  }
}

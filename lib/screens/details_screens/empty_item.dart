import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/screens/shared/detail_scaffold.dart';
import 'package:fladder/util/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptyItem extends ConsumerWidget {
  final ItemBaseModel item;
  const EmptyItem({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DetailScaffold(
      label: "Empty",
      content: (padding) =>
          Center(child: Text("Type of (Jelly.${item.jellyType?.name.capitalize()}) has not been implemented yet.")),
    );
  }
}

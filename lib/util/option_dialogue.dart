import 'package:flutter/material.dart';

Future<void> openOptionDialogue<T>(
  BuildContext context, {
  required String label,
  required List<T> items,
  bool isNullable = false,
  required Widget Function(T? type) itemBuilder,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(label),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              if (isNullable) itemBuilder(null),
              ...items.map(
                (e) => itemBuilder(e),
              )
            ],
          ),
        ),
      );
    },
  );
}

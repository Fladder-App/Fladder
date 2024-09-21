import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension ListExtensions on List<Widget> {
  List<Widget> addInBetween(Widget widget) {
    return mapIndexed(
      (index, element) {
        if (element != last) {
          return [element, widget];
        } else {
          return [element];
        }
      },
    ).expand((element) => element).toList();
  }

  List<Widget> addPadding(EdgeInsets padding) {
    return map((e) {
      if (e is Expanded || e is Spacer || e is Flexible) return e;
      return Padding(
        padding: padding.copyWith(
          top: e == first ? 0 : null,
          left: e == first ? 0 : null,
          right: e == last ? 0 : null,
          bottom: e == last ? 0 : null,
        ),
        child: e,
      );
    }).toList();
  }

  List<Widget> addSize({double? width, double? height}) {
    return map((e) {
      if (e is Expanded || e is Spacer || e is Flexible) return e;
      return SizedBox(
        width: width,
        height: height,
        child: e,
      );
    }).toList();
  }
}

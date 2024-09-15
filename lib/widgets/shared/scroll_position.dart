import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScrollState {
  top,
  middle,
  bottom,
}

class ScrollStatePosition extends ConsumerStatefulWidget {
  final ScrollController? controller;
  final Widget Function(ScrollState state) positionBuilder;

  const ScrollStatePosition({
    this.controller,
    required this.positionBuilder,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScrollStatePositionState();
}

class _ScrollStatePositionState extends ConsumerState<ScrollStatePosition> {
  late final scrollController = widget.controller ?? ScrollController();
  ScrollState scrollState = ScrollState.top;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(listen);
  }

  @override
  void dispose() {
    scrollController.removeListener(listen);
    super.dispose();
  }

  void listen() {
    if (scrollController.offset < scrollController.position.maxScrollExtent) {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          setState(() {
            scrollState = ScrollState.top;
          });
          print('At the top');
        } else {
          setState(() {
            scrollState = ScrollState.bottom;
          });
        }
      } else {
        setState(() {
          scrollState = ScrollState.middle;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.positionBuilder(scrollState);
  }
}

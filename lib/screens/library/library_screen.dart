import 'package:fladder/models/view_model.dart';
import 'package:fladder/providers/library_provider.dart';
import 'package:fladder/screens/library/components/library_tabs.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  const LibraryScreen({
    required this.viewModel,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> with SingleTickerProviderStateMixin {
  late final List<LibraryTabs> tabs = LibraryTabs.getLibraryForType(widget.viewModel, widget.viewModel.collectionType);
  late final TabController tabController = TabController(length: tabs.length, vsync: this);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(libraryProvider(widget.viewModel.id).notifier).setupLibrary(widget.viewModel);
    });

    tabController.addListener(() {
      if (tabController.previousIndex != tabController.index) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget tabBar = TabBar(
      isScrollable: AdaptiveLayout.of(context).isDesktop ? true : false,
      indicatorWeight: 3,
      controller: tabController,
      tabs: tabs
          .map((e) => Tab(
                text: e.name,
                icon: e.icon,
              ))
          .toList(),
    );

    return Padding(
      padding: AdaptiveLayout.of(context).isDesktop
          ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
          : EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AdaptiveLayout.of(context).isDesktop ? 15 : 0),
        child: Card(
          margin: AdaptiveLayout.of(context).isDesktop ? null : EdgeInsets.zero,
          elevation: 2,
          child: Scaffold(
            backgroundColor: AdaptiveLayout.of(context).isDesktop ? Colors.transparent : null,
            floatingActionButton: tabs[tabController.index].floatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AdaptiveLayout.of(context).isDesktop ? Colors.transparent : null,
              title: tabs.length > 1 ? (!AdaptiveLayout.of(context).isDesktop ? null : tabBar) : null,
              toolbarHeight: AdaptiveLayout.of(context).isDesktop ? 75 : 40,
              bottom: tabs.length > 1 ? (AdaptiveLayout.of(context).isDesktop ? null : tabBar) : null,
            ),
            extendBody: true,
            body: Padding(
              padding: !AdaptiveLayout.of(context).isDesktop
                  ? EdgeInsets.only(
                      left: MediaQuery.of(context).padding.left, right: MediaQuery.of(context).padding.right)
                  : EdgeInsets.zero,
              child: TabBarView(
                controller: tabController,
                children: tabs
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: e.page,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

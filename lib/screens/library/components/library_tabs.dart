// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fladder/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:fladder/screens/library/tabs/favourites_tab.dart';
import 'package:fladder/screens/library/tabs/library_tab.dart';
import 'package:fladder/screens/library/tabs/timeline_tab.dart';
import 'package:flutter/material.dart';

import 'package:fladder/models/view_model.dart';
import 'package:fladder/screens/library/tabs/recommendations_tab.dart';

class LibraryTabs {
  final String name;
  final Icon icon;
  final Widget page;
  final FloatingActionButton? floatingActionButton;
  LibraryTabs({
    required this.name,
    required this.icon,
    required this.page,
    this.floatingActionButton,
  });

  static List<LibraryTabs> getLibraryForType(ViewModel viewModel, CollectionType type) {
    LibraryTabs recommendTab() {
      return LibraryTabs(
        name: "Recommended",
        icon: const Icon(Icons.recommend_rounded),
        page: RecommendationsTab(viewModel: viewModel),
      );
    }

    LibraryTabs timelineTab() {
      return LibraryTabs(
        name: "Timeline",
        icon: const Icon(Icons.timeline),
        page: TimelineTab(viewModel: viewModel),
      );
    }

    LibraryTabs favouritesTab() {
      return LibraryTabs(
        name: "Favourites",
        icon: const Icon(Icons.favorite_rounded),
        page: FavouritesTab(viewModel: viewModel),
      );
    }

    LibraryTabs libraryTab() {
      return LibraryTabs(
        name: "Library",
        icon: const Icon(Icons.book_rounded),
        page: LibraryTab(viewModel: viewModel),
      );
    }

    switch (type) {
      case CollectionType.tvshows:
      case CollectionType.movies:
        return [
          libraryTab(),
          recommendTab(),
          favouritesTab(),
        ];
      case CollectionType.books:
      case CollectionType.homevideos:
        return [
          libraryTab(),
          timelineTab(),
          recommendTab(),
          favouritesTab(),
        ];
      case CollectionType.boxsets:
      case CollectionType.playlists:
      case CollectionType.folders:
        return [
          libraryTab(),
        ];
      default:
        return [];
    }
  }
}

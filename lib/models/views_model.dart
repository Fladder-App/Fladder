// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fladder/models/view_model.dart';

class ViewsModel {
  final bool loading;
  final List<ViewModel> views;
  final List<ViewModel> dashboardViews;
  ViewsModel({
    this.loading = false,
    this.views = const [],
    this.dashboardViews = const [],
  });

  ViewsModel copyWith({
    bool? loading,
    List<ViewModel>? views,
    List<ViewModel>? dashboardViews,
  }) {
    return ViewsModel(
        loading: loading ?? this.loading,
        views: views ?? this.views,
        dashboardViews: dashboardViews ?? this.dashboardViews);
  }
}

// lib/presentation/blocs/dashboard/dashboard_state.dart
import 'package:flutter/foundation.dart';
import '../../../data/models/dashboard_model.dart' as dashboard_model;
import '../../../data/models/video_model.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final dashboard_model.DashboardStatsModel stats;
  final List<VideoModel> videos;
  DashboardLoaded(this.stats, this.videos);
}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
// lib/data/models/dashboard_model.dart
import 'package:equatable/equatable.dart';

class DashboardStatsModel extends Equatable {
  final int totalVideos;
  final int totalViews;
  final int totalSubscribers;
  final int totalLikes;

  const DashboardStatsModel({
    required this.totalVideos,
    required this.totalViews,
    required this.totalSubscribers,
    required this.totalLikes,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalVideos: json['totalVideos'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalSubscribers: json['totalSubscribers'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [totalVideos, totalViews, totalSubscribers, totalLikes];
}

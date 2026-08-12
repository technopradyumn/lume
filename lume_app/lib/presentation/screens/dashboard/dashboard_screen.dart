import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../blocs/dashboard/dashboard_state.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/shimmer_loader.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Creator Dashboard')),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(4, (_) => const ShimmerLoader(height: 120)),
            );
          } else if (state is DashboardLoaded) {
            final stats = state.stats;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    StatCard(
                      label: 'Total Views',
                      value: '${stats.totalViews}',
                      icon: Icons.visibility_outlined,
                      color: AppColors.accentGlow,
                    ),
                    StatCard(
                      label: 'Subscribers',
                      value: '${stats.totalSubscribers}',
                      icon: Icons.people_outline,
                      color: AppColors.success,
                    ),
                    StatCard(
                      label: 'Videos',
                      value: '${stats.totalVideos}',
                      icon: Icons.video_collection_outlined,
                      color: AppColors.info,
                    ),
                    StatCard(
                      label: 'Total Likes',
                      color: AppColors.danger,
                      value: '${stats.totalLikes}',
                      icon: Icons.favorite_border,
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../blocs/dashboard/dashboard_state.dart';
import '../../widgets/video_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch dashboard data if not already loaded
    final currentState = context.read<DashboardCubit>().state;
    if (currentState is DashboardInitial) {
      context.read<DashboardCubit>().fetchDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Creator Studio')),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)));
          }
          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.textSubtle, size: 60),
                  const SizedBox(height: 12),
                  Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardCubit>().fetchDashboard(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is DashboardLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Grid
                  const Text('Channel Analytics', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        icon: Icons.play_circle_outline,
                        label: 'Total Videos',
                        value: '${state.stats.totalVideos}',
                        gradient: AppColors.primaryGradient,
                      ),
                      _StatCard(
                        icon: Icons.visibility_outlined,
                        label: 'Total Views',
                        value: _formatNum(state.stats.totalViews),
                        gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)]),
                      ),
                      _StatCard(
                        icon: Icons.people_outline,
                        label: 'Subscribers',
                        value: _formatNum(state.stats.totalSubscribers),
                        gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      ),
                      _StatCard(
                        icon: Icons.thumb_up_outlined,
                        label: 'Total Likes',
                        value: _formatNum(state.stats.totalLikes),
                        gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      const Text('Your Videos', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => context.push('/upload-video'),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Upload'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (state.videos.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.video_library_outlined, color: AppColors.textSubtle, size: 60),
                            SizedBox(height: 12),
                            Text('No videos yet', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.videos.length,
                      itemBuilder: (context, i) => VideoCard(
                        video: state.videos[i],
                        onTap: () => context.push('/video/${state.videos[i].id}'),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;
  const _StatCard({required this.icon, required this.label, required this.value, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

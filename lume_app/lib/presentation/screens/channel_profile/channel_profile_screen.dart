import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../widgets/channel_avatar.dart';

class ChannelProfileScreen extends StatefulWidget {
  final String username;

  const ChannelProfileScreen({super.key, required this.username});

  @override
  State<ChannelProfileScreen> createState() => _ChannelProfileScreenState();
}

class _ChannelProfileScreenState extends State<ChannelProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentStart));
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      user.coverImage ?? 'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?auto=format&fit=crop&w=1600&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ChannelAvatar(
                              imageUrl: user.avatar,
                              name: user.fullName,
                              size: 64,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '@${user.username}',
                                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('${user.subscribersCount ?? 0} Subscribers', style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 16),
                            Text('${user.channelsSubscribedToCount ?? 0} Subscribed', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
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

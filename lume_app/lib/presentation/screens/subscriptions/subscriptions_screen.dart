import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/subscription/subscription_cubit.dart';
import '../../blocs/subscription/subscription_state.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/shimmer_loader.dart';
import '../../widgets/empty_state.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const ShimmerLoader(height: 70),
            );
          } else if (state is SubscriptionLoaded) {
            if (state.channels.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.subscriptions_outlined,
                title: 'No subscriptions yet',
                description: 'Subscribe to channels to see their latest videos here.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.channels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final channel = state.channels[index];
                return GestureDetector(
                  onTap: () => context.push('/channel/${channel.username}'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: Row(
                      children: [
                        ChannelAvatar(
                          imageUrl: channel.avatar,
                          name: channel.fullName ?? 'U',
                          size: 48,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                channel.fullName ?? 'Channel',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '@${channel.username}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            context.read<SubscriptionCubit>().toggleSubscription(channel.id);
                          },
                          child: const Text('Subscribed'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is SubscriptionError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.danger)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// lib/presentation/screens/subscriptions/subscriptions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/subscription/subscription_cubit.dart';
import '../../blocs/subscription/subscription_state.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/channel_avatar.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch subscriptions if we don't already have them loaded
    final currentState = context.read<SubscriptionCubit>().state;
    if (currentState is SubscriptionInitial) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<SubscriptionCubit>().fetchSubscribedChannels(authState.user.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Subscriptions')),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)));
          }
          if (state is SubscriptionLoaded) {
            if (state.channels.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, color: AppColors.textSubtle, size: 80),
                    SizedBox(height: 16),
                    Text('No subscriptions yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Subscribe to channels you love', style: TextStyle(color: AppColors.textSubtle)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.channels.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final ch = state.channels[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: ChannelAvatar(imageUrl: ch.avatar, name: ch.fullName, size: 48),
                  title: Text(ch.fullName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  subtitle: Text('@${ch.username}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSubtle),
                  onTap: () => context.push('/channel/${ch.username}'),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Account', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.person_outline, color: AppColors.textPrimary),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: AppColors.textPrimary),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          const Divider(height: 32),
          const Text('Preferences', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined, color: AppColors.textPrimary),
            title: const Text('Dark Mode'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text('Sign Out', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
            onTap: () {
              context.read<AuthCubit>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

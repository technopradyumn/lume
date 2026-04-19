// lib/presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/gradient_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _fullNameCtrl.text = authState.user.fullName;
      _emailCtrl.text = authState.user.email;
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Updated successfully!'), backgroundColor: AppColors.success),
          );
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Settings')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final user = authState is AuthAuthenticated ? authState.user : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section
                  Center(
                    child: Stack(
                      children: [
                        ChannelAvatar(
                          imageUrl: user?.avatar,
                          name: user?.fullName ?? '',
                          size: 80,
                          showBorder: true,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final img = await _picker.pickImage(source: ImageSource.gallery);
                              if (img != null && mounted) {
                                context.read<ProfileCubit>().updateAvatar(img.path);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user != null) ...[
                    Center(
                      child: Text('@${user.username}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ),
                    const SizedBox(height: 28),

                    _SectionHeader('Account Details'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _fullNameCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.badge_outlined)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      text: 'Update Profile',
                      onPressed: () {
                        context.read<ProfileCubit>().updateAccountDetails(
                          fullName: _fullNameCtrl.text.trim(),
                          email: _emailCtrl.text.trim(),
                        );
                      },
                    ),

                    const SizedBox(height: 28),
                    _SectionHeader('Change Password'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _oldPassCtrl,
                      obscureText: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Old Password', prefixIcon: Icon(Icons.lock_outline)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newPassCtrl,
                      obscureText: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'New Password', prefixIcon: Icon(Icons.lock_reset)),
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      text: 'Change Password',
                      onPressed: () {
                        if (_oldPassCtrl.text.isNotEmpty && _newPassCtrl.text.isNotEmpty) {
                          context.read<AuthCubit>().changePassword(
                            oldPassword: _oldPassCtrl.text,
                            newPassword: _newPassCtrl.text,
                          );
                          _oldPassCtrl.clear();
                          _newPassCtrl.clear();
                        }
                      },
                    ),

                    const SizedBox(height: 28),
                    const Divider(),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.dashboard_outlined, color: AppColors.textSecondary),
                      title: const Text('Creator Studio', style: TextStyle(color: AppColors.textPrimary)),
                      subtitle: const Text('Manage your channel', style: TextStyle(color: AppColors.textSubtle, fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.textSubtle),
                      onTap: () => context.push('/dashboard'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.error),
                      title: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: const Text('Log Out', style: TextStyle(color: AppColors.textPrimary)),
                            content: const Text('Are you sure you want to log out?', style: TextStyle(color: AppColors.textSecondary)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Log Out'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && context.mounted) {
                          context.read<AuthCubit>().logout();
                        }
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700));
  }
}

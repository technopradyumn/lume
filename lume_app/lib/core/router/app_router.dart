// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/main_shell.dart';
import '../../presentation/screens/video_player/video_player_screen.dart';
import '../../presentation/screens/channel_profile/channel_profile_screen.dart';
import '../../presentation/screens/upload_video/upload_video_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const MainShell()),
    GoRoute(
      path: '/video/:videoId',
      builder: (_, state) => VideoPlayerScreen(videoId: state.pathParameters['videoId']!),
    ),
    GoRoute(
      path: '/channel/:username',
      builder: (_, state) => ChannelProfileScreen(username: state.pathParameters['username']!),
    ),
    GoRoute(path: '/upload-video', builder: (_, __) => const UploadVideoScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const MainShell()),
    GoRoute(path: '/playlist/:id', builder: (_, __) => const MainShell()),
  ],
);

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/video_repository.dart';
import 'data/repositories/tweet_repository.dart';
import 'data/repositories/comment_repository.dart';
import 'data/repositories/like_repository.dart';
import 'data/repositories/playlist_repository.dart';
import 'data/repositories/subscription_repository.dart';
import 'data/repositories/dashboard_repository.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/blocs/video/video_cubit.dart';
import 'presentation/blocs/tweet/tweet_cubit.dart';
import 'presentation/blocs/profile/profile_cubit.dart';
import 'presentation/blocs/comment/comment_cubit.dart';
import 'presentation/blocs/playlist/playlist_cubit.dart';
import 'presentation/blocs/subscription/subscription_cubit.dart';
import 'presentation/blocs/dashboard/dashboard_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF12121C),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Force portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize API client (Dio with interceptors)
  ApiClient().initialize();

  runApp(const LumeApp());
}

class LumeApp extends StatelessWidget {
  const LumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate repositories
    final authRepo = AuthRepository();
    final userRepo = UserRepository();
    final videoRepo = VideoRepository();
    final tweetRepo = TweetRepository();
    final commentRepo = CommentRepository();
    final likeRepo = LikeRepository();
    final playlistRepo = PlaylistRepository();
    final subscriptionRepo = SubscriptionRepository();
    final dashboardRepo = DashboardRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authRepository: authRepo,
          ),
        ),
        BlocProvider<VideoCubit>(
          create: (_) => VideoCubit(
            videoRepository: videoRepo,
            likeRepository: likeRepo,
          ),
        ),
        BlocProvider<TweetCubit>(
          create: (_) => TweetCubit(
            tweetRepository: tweetRepo,
            likeRepository: likeRepo,
          ),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(
            userRepository: userRepo,
            subscriptionRepository: subscriptionRepo,
          ),
        ),
        BlocProvider<CommentCubit>(
          create: (_) => CommentCubit(
            commentRepository: commentRepo,
            likeRepository: likeRepo,
          ),
        ),
        BlocProvider<PlaylistCubit>(
          create: (_) => PlaylistCubit(playlistRepository: playlistRepo),
        ),
        BlocProvider<SubscriptionCubit>(
          create: (_) => SubscriptionCubit(subscriptionRepository: subscriptionRepo),
        ),
        BlocProvider<DashboardCubit>(
          create: (_) => DashboardCubit(dashboardRepository: dashboardRepo),
        ),
      ],
      child: MaterialApp.router(
        title: 'Lume',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: appRouter,
        builder: (context, child) {
          // Clamp text scaling to prevent layout overflow
          final mediaQuery = MediaQuery.of(context);
          final data = mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.2,
            ),
          );
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                appRouter.go('/login');
              } else if (state is AuthAuthenticated) {
                appRouter.go('/home');
              }
            },
            child: MediaQuery(data: data, child: child!),
          );
        },
      ),
    );
  }
}

// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String register = '/users/register';
  static const String login = '/users/login';
  static const String logout = '/users/logout';
  static const String refreshToken = '/users/refresh-token';
  static const String changePassword = '/users/change-password';

  // User
  static const String currentUser = '/users/current-user';
  static const String updateAccount = '/users/update-account';
  static const String updateAvatar = '/users/avatar';
  static const String updateCoverImage = '/users/cover-image';
  static String channelProfile(String username) => '/users/c/$username';
  static const String watchHistory = '/users/history';

  // Videos
  static const String videos = '/videos';
  static String videoById(String id) => '/videos/$id';
  static String deleteVideo(String id) => '/videos/$id';
  static String updateVideo(String id) => '/videos/$id';
  static String togglePublish(String id) => '/videos/toggle/publish/$id';

  // Tweets
  static const String tweets = '/tweets';
  static String userTweets(String userId) => '/tweets/user/$userId';
  static String tweetById(String id) => '/tweets/$id';

  // Subscriptions
  static String channelSubscription(String channelId) => '/subscriptions/c/$channelId';
  static String userSubscribers(String subscriberId) => '/subscriptions/u/$subscriberId';

  // Likes
  static String toggleVideoLike(String videoId) => '/likes/toggle/v/$videoId';
  static String toggleCommentLike(String commentId) => '/likes/toggle/c/$commentId';
  static String toggleTweetLike(String tweetId) => '/likes/toggle/t/$tweetId';
  static const String likedVideos = '/likes/videos';

  // Comments
  static String videoComments(String videoId) => '/comments/$videoId';
  static String commentById(String commentId) => '/comments/c/$commentId';

  // Playlists
  static const String playlists = '/playlist';
  static String playlistById(String id) => '/playlist/$id';
  static String userPlaylists(String userId) => '/playlist/user/$userId';
  static String addVideoToPlaylist(String videoId, String playlistId) =>
      '/playlist/add/$videoId/$playlistId';
  static String removeVideoFromPlaylist(String videoId, String playlistId) =>
      '/playlist/remove/$videoId/$playlistId';

  // Dashboard
  static const String channelStats = '/dashboard/stats';
  static const String channelVideos = '/dashboard/videos';

  // Healthcheck
  static const String healthcheck = '/healthcheck';
}

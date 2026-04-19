// lib/core/utils/date_formatter.dart
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String timeAgo(DateTime dateTime) {
    return timeago.format(dateTime, locale: 'en_short');
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  static String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String formatViewCount(int views) {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M views';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}K views';
    return '$views views';
  }

  static String formatSubscriberCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M subscribers';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K subscribers';
    return '$count subscribers';
  }
}

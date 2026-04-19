// lib/presentation/blocs/comment/comment_state.dart
import 'package:flutter/foundation.dart';
import '../../../data/models/comment_model.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}
class CommentLoading extends CommentState {}
class CommentsLoaded extends CommentState {
  final List<CommentModel> comments;
  CommentsLoaded(this.comments);
}
class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}
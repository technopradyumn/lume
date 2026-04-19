// lib/presentation/blocs/comment/comment_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/comment_repository.dart';
import '../../../data/repositories/like_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository _commentRepo;
  final LikeRepository _likeRepo;

  CommentCubit({
    required CommentRepository commentRepository,
    required LikeRepository likeRepository,
  })  : _commentRepo = commentRepository,
        _likeRepo = likeRepository,
        super(CommentInitial());

  Future<void> fetchComments(String videoId) async {
    emit(CommentLoading());
    try {
      final comments = await _commentRepo.getVideoComments(videoId);
      emit(CommentsLoaded(comments));
    } catch (e) {
      emit(CommentError(extractErrorMessage(e)));
    }
  }

  Future<void> addComment(String videoId, String content) async {
    try {
      await _commentRepo.addComment(videoId: videoId, content: content);
      await fetchComments(videoId);
    } catch (e) {
      emit(CommentError(extractErrorMessage(e)));
    }
  }

  Future<void> updateComment(String videoId, String commentId, String content) async {
    try {
      await _commentRepo.updateComment(commentId, content);
      await fetchComments(videoId);
    } catch (e) {
      emit(CommentError(extractErrorMessage(e)));
    }
  }

  Future<void> deleteComment(String videoId, String commentId) async {
    try {
      await _commentRepo.deleteComment(commentId);
      await fetchComments(videoId);
    } catch (e) {
      emit(CommentError(extractErrorMessage(e)));
    }
  }

  Future<void> toggleLike(String commentId) async {
    try {
      await _likeRepo.toggleCommentLike(commentId);
    } catch (e) {
      emit(CommentError(extractErrorMessage(e)));
    }
  }
}

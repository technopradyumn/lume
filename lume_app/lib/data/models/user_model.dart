// lib/data/models/user_model.dart
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String avatar;
  final String? coverImage;
  final int? subscribersCount;
  final int? channelsSubscribedToCount;
  final bool? isSubscribed;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.avatar,
    this.coverImage,
    this.subscribersCount,
    this.channelsSubscribedToCount,
    this.isSubscribed,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
      coverImage: json['coverImage'],
      subscribersCount: json['subscribersCount'],
      channelsSubscribedToCount: json['channelsSubscribedToCount'],
      isSubscribed: json['isSubscribed'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'username': username,
    'email': email,
    'fullName': fullName,
    'avatar': avatar,
    'coverImage': coverImage,
  };

  UserModel copyWith({
    String? avatar,
    String? coverImage,
    String? fullName,
    String? email,
    bool? isSubscribed,
    int? subscribersCount,
  }) {
    return UserModel(
      id: id,
      username: username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      subscribersCount: subscribersCount ?? this.subscribersCount,
      channelsSubscribedToCount: channelsSubscribedToCount,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, username, email, fullName, avatar, coverImage, isSubscribed];
}

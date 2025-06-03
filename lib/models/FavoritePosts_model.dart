
import 'package:get/get.dart';

class FavoritePostsResponse {
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final List<FavoritePost> favoritePosts;

  
  FavoritePostsResponse({
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.favoritePosts,
  });

  factory FavoritePostsResponse.fromJson(Map<String, dynamic> json) {
    return FavoritePostsResponse(
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
      favoritePosts: (json['posts'] as List).map((e) => FavoritePost.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'favoritePosts': favoritePosts.map((e) => e.toJson()).toList(),
    };
  }
}

class FavoritePost {
  final int postId;
  final String? title;
  final String content;
  final String? imageUrl;
  final RxInt likesCount;
  final RxInt commentsCount;
  final RxBool isLikedByUser;
    final DateTime publishedAt;
  final MedicalCenter medicalCenter;

    FavoritePost({
    required this.postId,
     this.title,
     this.imageUrl,
    required this.content,
    required int likesCount,
    required  int commentsCount,
    required bool isLikedByUser,
    required this.publishedAt,
    required this.medicalCenter,
  })  : likesCount = RxInt(likesCount),
        isLikedByUser = RxBool(isLikedByUser),
        commentsCount = RxInt(commentsCount);

  factory FavoritePost.fromJson(Map<String, dynamic> json) {
    return FavoritePost(
      postId: json['postId'],
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      content: json['content'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      isLikedByUser: json['isLikedByUser'],
      publishedAt: DateTime.parse(json['publishedAt']),
      medicalCenter: MedicalCenter.fromJson(json['medicalCenter']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLikedByUser': isLikedByUser,
      'publishedAt': publishedAt.toIso8601String(),
      'medicalCenter': medicalCenter.toJson(),
    };
  }
}

class MedicalCenter {
  final int medicalCenterId;
  final String name;
  final String logoImageUrl;

  MedicalCenter({
    required this.medicalCenterId,
    required this.name,
    required this.logoImageUrl,
  });

  factory MedicalCenter.fromJson(Map<String, dynamic> json) {
    return MedicalCenter(
      medicalCenterId: json['medicalCenterId'],
      name: json['name'],
      logoImageUrl: json['logoImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalCenterId': medicalCenterId,
      'name': name,
      'logoImageUrl': logoImageUrl,
    };
  }
}

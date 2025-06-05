
import 'package:get/get.dart';

class Post {
  final int id;
  final String text;
  final String imageUrl;
  final DateTime createdAt;
  final RxInt likesCount;
  final RxInt commentsCount;
  final RxBool isLiked;
  final MedicalCenter medicalCenter;

  Post({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.medicalCenter,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'],
    text: json['text'],
    imageUrl: json['imageUrl'],
    createdAt: DateTime.parse(json['createdAt']),
    likesCount: RxInt(json['likesCount']),  // 🔹 Wrap in RxInt
    commentsCount: RxInt(json['commentsCount']),  // 🔹 Wrap in RxInt
    isLiked: RxBool(json['isLiked']),  // 🔹 Wrap in RxBool
    medicalCenter: MedicalCenter.fromJson(json['medicalCenter']),
  );
}

 Map<String, dynamic> toJson() {
  return {
    'id': id,
    'text': text,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'likesCount': likesCount.value,  // 🔹 Extract value
    'commentsCount': commentsCount.value,  // 🔹 Extract value
    'isLiked': isLiked.value,  // 🔹 Extract value
    'medicalCenter': medicalCenter.toJson(),
  };
}

  static List<Post> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Post.fromJson(json)).toList();
  }
}

class MedicalCenter {
  final int medicalCentersId;
  final String medicalCentersName;
  final String? category;
  final String logoImageUrl;

  MedicalCenter({
    required this.medicalCentersId,
    required this.medicalCentersName,
     this.category,
    required this.logoImageUrl,
  });

  factory MedicalCenter.fromJson(Map<String, dynamic> json) {
    return MedicalCenter(
      medicalCentersId: json['medicalCentersId'],
      medicalCentersName: json['medicalCentersName'],
      category: json['category'],
      logoImageUrl: json['logoImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalCentersId': medicalCentersId,
      'medicalCentersName': medicalCentersName,
      'category': category,
      'logoImageUrl': logoImageUrl,
    };
  }
}

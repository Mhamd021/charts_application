class ReviewModel {
  final int id;
  final int medicalCenterId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String userId;
  final String userName;
  final String? userProfilePictureUrl;

  ReviewModel({
    required this.id,
    required this.medicalCenterId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.userId,
    required this.userName,
    this.userProfilePictureUrl,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      medicalCenterId: json['medicalCenterId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      userName: json['userName'],
      userProfilePictureUrl: json['userProfilePictureUrl'],
    );
  }
}

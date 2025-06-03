class Comment {
  final int commentId;
  final int postId;
  final String userId;
  final String commentText;
  final String userName;

  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.commentText,
    required this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
  return Comment(
    commentId: json['commentId'] ?? 0, // Ensure numeric default
    postId: json['postId'] ?? 0,
    userId: json['userId'] ?? '',
    commentText: json['commentText'] ?? '', // 🔥 Prevent null errors
    userName: json['userName'] ?? 'Unknown', // 🔥 Default if missing
  );
}

  static List<Comment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Comment.fromJson(json)).toList();
  }
}

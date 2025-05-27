class Comment {
int id ;
int userId;
int postId;
String commentInfo;
String? commentImage;
String createdAt;
String updatedAt;
User user;

  Comment({
  required this.id,
  required this.userId,
  required this.postId,
  required this.commentInfo,
  this.commentImage,
  required this.createdAt,
  required this.updatedAt,
  required this.user,



});

factory Comment.fromJson(Map<String,dynamic> json)
{
  return Comment 
  (
    id : json['id'],
    userId: json['user_id'],
    postId: json['post_id'],
    commentInfo: json['comment_info'],
    commentImage: json['comment_image'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    user: User.fromJson(json['user'])

  );
}

}


class User 
{
  int id ;
  String name;
  String? userImage;
   User({required this.id, required this.name, this.userImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      userImage: json['user_image'] ?? '', 
    );
  }
}
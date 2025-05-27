class Like {
 late List<int> count;
  late List<Likes> likes;

  Like({required this.count
  ,
   required this.likes});

  Like.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes.add( Likes.fromJson(v));
      });
    }
  }  
}

class Likes {
  int? id;
  int? userId;
  int? postId;
  String? createdAt;
  String? updatedAt;
  User? user;

  Likes(
      {this.id,
      this.userId,
      this.postId,
      this.createdAt,
      this.updatedAt,
      this.user});

  Likes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ?  User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['post_id'] = postId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
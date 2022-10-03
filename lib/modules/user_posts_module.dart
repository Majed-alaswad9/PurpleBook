import 'package:html_unescape/html_unescape.dart';

class UserPostsModule {
  List<Posts>? posts;

  UserPostsModule({this.posts});

  UserPostsModule.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
var unescape = HtmlUnescape();
class Posts {
  String? sId;
  String? content;
  ImageModule? image;
  DateTime? createdAt;
  bool? likedByUser;
  int? likesCount;
  int? commentsCount;

  Posts(
      {this.sId,
        this.content,
        this.image,
        this.createdAt,
        this.likedByUser,
        this.likesCount,
        this.commentsCount});

  Posts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = unescape.convert(json['content']);
    image = json['image'] != null ? ImageModule.fromJson(json['image']) : null;
    createdAt = DateTime.parse( json['createdAt']);
    likedByUser = json['likedByUser'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['createdAt'] = createdAt;
    data['likedByUser'] = likedByUser;
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    return data;
  }
}

class ImageModule {
  String? data;
  String? contentType;

  ImageModule({this.data, this.contentType});

  ImageModule.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['contentType'] = contentType;
    return data;
  }
}

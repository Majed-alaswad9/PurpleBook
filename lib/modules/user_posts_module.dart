import 'package:html_unescape/html_unescape.dart';

class UserPostsModule {
  List<UserPosts>? posts;

  UserPostsModule({this.posts});

  UserPostsModule.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <UserPosts>[];
      json['posts'].forEach((v) {
        posts!.add(UserPosts.fromJson(v));
      });
    }
  }
}

var unescape = HtmlUnescape();

class UserPosts {
  String? sId;
  String? content;
  ImageModule? image;
  DateTime? createdAt;
  bool? likedByUser;
  int? likesCount;
  int? commentsCount;

  UserPosts(
      {this.sId,
      this.content,
      this.image,
      this.createdAt,
      this.likedByUser,
      this.likesCount,
      this.commentsCount});

  UserPosts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = unescape.convert(json['content']);
    image = json['image'] != null ? ImageModule.fromJson(json['image']) : null;
    createdAt = DateTime.parse(json['createdAt']);
    likedByUser = json['likedByUser'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
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
}

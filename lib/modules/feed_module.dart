import 'package:html_unescape/html_unescape.dart';

class FeedModule {
  List<Posts>? posts;

  FeedModule({this.posts});

  FeedModule.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
  }
}

class Posts {
  String? sId;
  String? content;
  ImageModule? image;
  DateTime? createdAt;
  Author? author;
  bool? likedByUser;
  int? likesCount;
  int? commentsCount;

  Posts(
      {this.sId,
      this.content,
      this.image,
      this.createdAt,
      this.author,
      this.likedByUser,
      this.likesCount,
      this.commentsCount});

  var unescape = HtmlUnescape();
  Posts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = unescape.convert(json['content']);
    image = json['image'] != null ? ImageModule.fromJson(json['image']) : null;
    createdAt = DateTime.parse(json['createdAt']);
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
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

class Author {
  String? sId;
  String? firstName;
  String? lastName;
  ImageModule? imageMini;

  Author({this.sId, this.firstName, this.lastName, this.imageMini});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageMini = json['imageMini'] != null
        ? ImageModule.fromJson(json['imageMini'])
        : null;
  }
}

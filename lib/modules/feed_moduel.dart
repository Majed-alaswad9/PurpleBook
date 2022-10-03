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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  String? sId;
  String? content;
  ImageModule? image;
  String? createdAt;
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
    createdAt = json['createdAt'];
    author =
    json['author'] != null ? Author.fromJson(json['author']) : null;
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
    if (author != null) {
      data['author'] = author!.toJson();
    }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    if (imageMini != null) {
      data['imageMini'] = imageMini!.toJson();
    }
    return data;
  }
}

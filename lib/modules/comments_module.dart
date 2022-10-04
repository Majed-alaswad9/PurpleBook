import 'package:html_unescape/html_unescape.dart';

class CommentsModule {
  List<Comments>? comments;

  CommentsModule({this.comments});

  CommentsModule.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? sId;
  String? content;
  DateTime? createdAt;
  int? likesCount;
  Author? author;
  bool? likedByUser;

  Comments(
      {this.sId,
        this.content,
        this.createdAt,
        this.likesCount,
        this.author,
        this.likedByUser});

  var unescape = HtmlUnescape();
  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = unescape.convert(json['content']);
    createdAt = DateTime.parse( json['createdAt']);
    likesCount = json['likesCount'];
    author =
    json['author'] != null ? Author.fromJson(json['author']) : null;
    likedByUser = json['likedByUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['likesCount'] = likesCount;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['likedByUser'] = likedByUser;
    return data;
  }
}

class Author {
  String? sId;
  String? firstName;
  String? lastName;
  ImageMini? imageMini;

  Author({this.sId, this.firstName, this.lastName, this.imageMini});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageMini = json['imageMini'] != null
        ? ImageMini.fromJson(json['imageMini'])
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

class ImageMini {
  String? data;
  String? contentType;

  ImageMini({this.data, this.contentType});

  ImageMini.fromJson(Map<String, dynamic> json) {
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

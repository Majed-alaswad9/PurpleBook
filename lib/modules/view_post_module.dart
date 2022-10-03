import 'package:html_unescape/html_unescape.dart';

class ViewPostModule {
  Post? post;

  ViewPostModule({this.post});

  ViewPostModule.fromJson(Map<String, dynamic> json) {
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (post != null) {
      data['post'] = post!.toJson();
    }
    return data;
  }
}

class Post {
  String? sId;
  String? content;
  Image? image;
  String? createdAt;
  Author? author;
  bool? likedByUser;
  int? likesCount;

  Post(
      {this.sId,
        this.content,
        this.image,
        this.createdAt,
        this.author,
        this.likedByUser,
        this.likesCount});

  var unescape = HtmlUnescape();
  Post.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = unescape.convert(json['content']);
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    createdAt = json['createdAt'];
    author =
    json['author'] != null ? Author.fromJson(json['author']) : null;
    likedByUser = json['likedByUser'];
    likesCount = json['likesCount'];
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
    return data;
  }
}

class Image {
  String? data;
  String? contentType;

  Image({this.data, this.contentType});

  Image.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['data'] = this.data;
    data['contentType'] = contentType;
    return data;
  }
}

class Author {
  String? sId;
  String? firstName;
  String? lastName;
  Image? imageMini;

  Author({this.sId, this.firstName, this.lastName, this.imageMini});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageMini = json['imageMini'] != null
        ? Image.fromJson(json['imageMini'])
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

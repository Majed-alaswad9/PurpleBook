import 'package:html_unescape/html_unescape.dart';

class UserCommentsModule {
  List<UserComments>? comments;

  UserCommentsModule({this.comments});

  UserCommentsModule.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <UserComments>[];
      json['comments'].forEach((v) {
        comments!.add(UserComments.fromJson(v));
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

var unescape = HtmlUnescape();
class UserComments {
  String? sId;
  String? content;
  String? createdAt;
  Post? post;
  bool? likedByUser;
  int? likesCount;


  UserComments(
      {this.sId,
        this.content,
        this.createdAt,
        this.post,
        this.likedByUser,
        this.likesCount});

  UserComments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = unescape.convert(json['content']);
    createdAt = json['createdAt'];
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
    likedByUser = json['likedByUser'];
    likesCount = json['likesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['createdAt'] = createdAt;
    if (post != null) {
      data['post'] = post!.toJson();
    }
    data['likedByUser'] = likedByUser;
    data['likesCount'] = likesCount;
    return data;
  }
}

class Post {
  String? sId;
  String? postAuthorFirstName;
  String? contentPreview;

  Post({this.sId, this.postAuthorFirstName, this.contentPreview});

  Post.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    postAuthorFirstName = json['postAuthorFirstName'];
    contentPreview = unescape.convert(json['contentPreview']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['postAuthorFirstName'] = postAuthorFirstName;
    data['contentPreview'] = contentPreview;
    return data;
  }
}

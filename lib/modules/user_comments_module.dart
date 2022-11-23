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
}

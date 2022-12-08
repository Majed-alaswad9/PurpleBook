class ViewSingleCommentModule {
  Comment? comment;

  ViewSingleCommentModule({this.comment});

  ViewSingleCommentModule.fromJson(Map<String, dynamic> json) {
    comment =
        json['comment'] != null ? Comment.fromJson(json['comment']) : null;
  }
}

class Comment {
  String? sId;
  String? content;
  DateTime? createdAt;
  Author? author;
  bool? likedByUser;
  int? likesCount;

  Comment(
      {this.sId,
      this.content,
      this.createdAt,
      this.author,
      this.likedByUser,
      this.likesCount});

  Comment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    createdAt = DateTime.parse(json['createdAt']);
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    likedByUser = json['likedByUser'];
    likesCount = json['likesCount'];
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
}

class ImageMini {
  String? data;
  String? contentType;

  ImageMini({this.data, this.contentType});

  ImageMini.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    contentType = json['contentType'];
  }
}

class UserFriendsModule {
  List<Friends>? friends;

  UserFriendsModule({this.friends});

  UserFriendsModule.fromJson(Map<String, dynamic> json) {
    if (json['friends'] != null) {
      friends = <Friends>[];
      json['friends'].forEach((v) {
        friends!.add(Friends.fromJson(v));
      });
    }
  }
}

class Friends {
  String? sId;
  String? firstName;
  String? lastName;
  ImageMini? imageMini;
  String? friendState;

  Friends(
      {this.sId,
      this.firstName,
      this.lastName,
      this.imageMini,
      this.friendState});

  Friends.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageMini = json['imageMini'] != null
        ? ImageMini.fromJson(json['imageMini'])
        : null;
    friendState = json['friendState'];
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

class UserProfileModule {
  User? user;

  UserProfileModule({this.user});

  UserProfileModule.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  ImageFull? imageFull;
  String? sId;
  String? firstName;
  String? lastName;
  String? createdAt;
  String? friendState;

  User(
      {this.imageFull,
      this.sId,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.friendState});

  User.fromJson(Map<String, dynamic> json) {
    imageFull = json['imageFull'] != null
        ? ImageFull.fromJson(json['imageFull'])
        : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    createdAt = json['createdAt'];
    friendState = json['friendState'];
  }
}

class ImageFull {
  Data? data;
  String? contentType;

  ImageFull({this.data, this.contentType});

  ImageFull.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    contentType = json['contentType'];
  }
}

class Data {
  String? type;
  List<int>? data;

  Data({this.type, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'].cast<int>();
  }
}

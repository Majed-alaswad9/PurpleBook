class LikesModule {
  List<Users>? users;

  LikesModule({this.users});

  LikesModule.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }
}

class Users {
  ImageMini? imageMini;
  String? sId;
  String? firstName;
  String? lastName;
  String? friendState;

  Users(
      {this.imageMini,
      this.sId,
      this.firstName,
      this.lastName,
      this.friendState});

  Users.fromJson(Map<String, dynamic> json) {
    imageMini = json['imageMini'] != null
        ? ImageMini.fromJson(json['imageMini'])
        : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    friendState = json['friendState'];
  }
}

class ImageMini {
  Data? data;
  String? contentType;

  ImageMini({this.data, this.contentType});

  ImageMini.fromJson(Map<String, dynamic> json) {
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

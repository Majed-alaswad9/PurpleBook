class FriendsRequestModule {
  List<FriendRequests>? friendRequests;

  FriendsRequestModule({this.friendRequests});

  FriendsRequestModule.fromJson(Map<String, dynamic> json) {
    if (json['friendRequests'] != null) {
      friendRequests = <FriendRequests>[];
      json['friendRequests'].forEach((v) {
        friendRequests!.add(FriendRequests.fromJson(v));
      });
    }
  }
}

class FriendRequests {
  User? user;
  bool? viewed;
  String? sId;

  FriendRequests({this.user, this.viewed, this.sId});

  FriendRequests.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    viewed = json['viewed'];
    sId = json['_id'];
  }
}

class User {
  ImageMini? imageMini;
  String? sId;
  String? firstName;
  String? lastName;

  User({this.imageMini, this.sId, this.firstName, this.lastName});

  User.fromJson(Map<String, dynamic> json) {
    imageMini = json['imageMini'] != null
        ? ImageMini.fromJson(json['imageMini'])
        : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
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

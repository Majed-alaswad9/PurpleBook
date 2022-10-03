class FriendRecommendationModule {

  List<FriendRecommendation>? friendRecommendation;
  FriendRecommendationModule({this.friendRecommendation});

  FriendRecommendationModule.fromJson(Map<String, dynamic> json) {
    if (json['friendRecommendation'] != null) {
      friendRecommendation = <FriendRecommendation>[];
      json['friendRecommendation'].forEach((v) {
          friendRecommendation!.add(FriendRecommendation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (friendRecommendation != null) {
      data['friendRecommendation'] =
          friendRecommendation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FriendRecommendation {
  String? sId;
  String? firstName;
  String? lastName;
  ImageMini? imageMini;
  int? mutualFriends;
  String? friendState;

  FriendRecommendation(
      {this.sId,
        this.firstName,
        this.lastName,
        this.imageMini,
        this.mutualFriends,
        this.friendState});

  FriendRecommendation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageMini = json['imageMini'] != null
        ? ImageMini.fromJson(json['imageMini'])
        : null;
    mutualFriends = json['mutualFriends'];
    friendState = json['friendState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    if (imageMini != null) {
      data['imageMini'] = imageMini!.toJson();
    }
    data['mutualFriends'] = mutualFriends;
    data['friendState'] = friendState;
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

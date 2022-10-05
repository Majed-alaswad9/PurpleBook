import 'package:html_unescape/html_unescape.dart';

class NotificationsModule {
  List<Notifications>? notifications;

  NotificationsModule({this.notifications});

  NotificationsModule.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

var unescape = HtmlUnescape();

class Notifications {
  Image? image;
  String? sId;
  List<Links>? links;
  String? content;
  bool? viewed;
  DateTime? createdAt;
  int? iV;

  Notifications(
      {this.image,
      this.sId,
      this.links,
      this.content,
      this.viewed,
      this.createdAt,
      this.iV});

  Notifications.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    sId = json['_id'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    content = unescape.convert(json['content']);
    viewed = json['viewed'];
    createdAt = DateTime.parse(json['createdAt']);
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['_id'] = sId;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['content'] = content;
    data['viewed'] = viewed;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}

class Image {
  Data? data;
  String? contentType;

  Image({this.data, this.contentType});

  Image.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['contentType'] = contentType;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['data'] = this.data;
    return data;
  }
}

class Links {
  String? linkId;
  String? ref;
  String? sId;

  Links({this.linkId, this.ref, this.sId});

  Links.fromJson(Map<String, dynamic> json) {
    linkId = json['linkId'];
    ref = json['ref'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['linkId'] = linkId;
    data['ref'] = ref;
    data['_id'] = sId;
    return data;
  }
}

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
}

var unescape = HtmlUnescape();

class Notifications {
  String? sId;
  Image? image;
  List<Links>? links;
  String? content;
  bool? viewed;
  DateTime? createdAt;
  int? iV;

  Notifications(
      {this.sId,
      this.image,
      this.links,
      this.content,
      this.viewed,
      this.createdAt,
      this.iV});

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
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
}

class Image {
  String? data;
  String? contentType;

  Image({this.data, this.contentType});

  Image.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    contentType = json['contentType'];
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
}

class LogInModule {
  String? userId;
  String? token;
  bool isAdmin = false;

  LogInModule({this.userId, this.token});

  LogInModule.fromJson(Map<String, dynamic> json) {
    if (json.length == 2) {
      userId = json['userId'];
      token = json['token'];
    } else {
      userId = json['userId'];
      token = json['token'];
      isAdmin = json['isAdmin'];
    }
  }
}

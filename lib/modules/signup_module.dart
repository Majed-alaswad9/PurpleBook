class SignupModule {
  String? userId;

  SignupModule({this.userId});

  SignupModule.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }
}

import 'package:purplebook/modules/login_module.dart';

abstract class LoginSignupState {}

class InitialLogInState extends LoginSignupState {}

class LoginSuccessState extends LoginSignupState {
  final LogInModule logInModel;

  LoginSuccessState(this.logInModel);
}

class LoginLoadState extends LoginSignupState {}

class LoginErrorState extends LoginSignupState {
  final String error;

  LoginErrorState(this.error);
}

class SignupSuccessState extends LoginSignupState {}

class SignupLoadState extends LoginSignupState {}

class SignupErrorState extends LoginSignupState {
  final String error;
  SignupErrorState(this.error);
}

class ChangeVisibilityState extends LoginSignupState {}

class GetImageProfileSuccessState extends LoginSignupState {}

class GetImageProfileErrorState extends LoginSignupState {}

class DeletePhotoSuccessState extends LoginSignupState {}
